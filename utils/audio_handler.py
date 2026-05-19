import librosa
from utils.alignment import forced_align, processor

IPA_TOKENS = [
    "dʒ", "aː", "iː", "uː", "s̪", "t̪", "dˤ", "ðˤ",
    "ʕ", "ħ", "θ", "ð", "ʃ", "ɹ", "ʔ", "χ",
    "q", "x", "b", "t", "d", "f", "k",
    "l", "m", "n", "h", "w", "j", "z",
    "s", "r", "a", "i", "u",
]

ARABIC_TO_PHONEME = {
    "ع": "ʕ", "ا": "aː", "ب": "b", "ت": "t",
    "ث": "θ", "ج": "dʒ", "ح": "ħ", "خ": "x",
    "د": "d", "ذ": "ð", "ر": "ɹ", "ز": "z",
    "س": "s", "ش": "ʃ", "ص": "S", "ض": "dˤ",
    "ط": "T", "ظ": "ðˤ", "ف": "f", "ق": "q",
    "ك": "k", "ل": "l", "م": "m", "ن": "n",
    "ه": "h", "و": "w", "ي": "j", "ء": "ʔ",
    "َ": "a", "ِ": "i", "ُ": "u",
    "ً": "an", "ٍ": "in", "ٌ": "un",
    "~": "aʔaː",
}

PHONEME_TO_ARABIC = {v: k for k, v in ARABIC_TO_PHONEME.items()}

EQUIVALENCE_MAP = {
    'a': ['a', 'A', 'aː'],
    'i': ['i', 'Y', 'iː'],
    'u': ['u', 'W', 'uː'],
}

CONFUSION_MAP = {
    "s": ["S", "θ"], "S": ["s", "θ"], "k": ["q"], "q": ["k"],
    "θ": ["s", "S"], "h": ["ħ"], "ħ": ["h"], "t": ["T"], "T": ["t"],
    "aː": ["ʕ", "aʔaː", "a"], "ʕ": ["aː"], "a": ["aː"], "aʔaː": ["aː"],
    "ð": ["dˤ", "z", "ðˤ"], "z": ["dˤ", "ð", "ðˤ"],
    "dˤ": ["ð", "z", "ðˤ"], "ðˤ": ["ð", "z", "dˤ"],
}

FEEDBACK_RULES = {
    ("ħ", "h"): "Practise HuruF E Halqi properly.",
    ("h", "ħ"): "Practise HuruF E Halqi properly.",
    ("aː", "ʕ"): "Practise HuruF E Halqi properly.",
    ("ʕ", "aː"): "Alif without Halaq.",
    ("q", "k"): "ق should be Heavy (back of throat).",
    ("k", "q"): "ک should be light (front of mouth).",
    ("s", "θ"): "س with whistle sound.",
    ("θ", "s"): "ث from tongue tip (between teeth).",
    ("S", "θ"): "ص with rolled lips (emphatic).",
    ("θ", "S"): "ث from tongue tip.",
    ("S", "s"): "ص with rolled lips (heavy).",
    ("s", "S"): "س with whistle sound (light).",
    ("t", "T"): "ت should be light.",
    ("T", "t"): "ط should be heavy with rolled lips.",
    ("ð", "z"): "Thaal (ذ) vs Zay (ز): soft th vs buzzing z.",
    ("z", "ð"): "Zay (ز) vs Thaal (ذ): buzzing z vs soft th.",
    ("ð", "dˤ"): "Thaal (ذ) vs Daad (ض): soft th vs emphatic d.",
    ("dˤ", "ð"): "Daad (ض) vs Thaal (ذ): emphatic d vs soft th.",
    ("ð", "ðˤ"): "Thaal (ذ) vs Zaa (ظ): soft th vs emphatic dh.",
    ("ðˤ", "ð"): "Zaa (ظ) vs Thaal (ذ): emphatic dh vs soft th.",
    ("z", "dˤ"): "Zay (ز) vs Daad (ض): buzzing z vs emphatic d.",
    ("dˤ", "z"): "Daad (ض) vs Zay (ز): emphatic d vs buzzing z.",
    ("z", "ðˤ"): "Zay (ز) vs Zaa (ظ): buzzing z vs emphatic dh.",
    ("ðˤ", "z"): "Zaa (ظ) vs Zay (ز): emphatic dh vs buzzing z.",
    ("dˤ", "ðˤ"): "Daad (ض) vs Zaa (ظ): emphatic d vs emphatic dh.",
    ("ðˤ", "dˤ"): "Zaa (ظ) vs Daad (ض): emphatic dh vs emphatic d.",
}

# IKHFA
IKHFA_TRIGGERS = ['t', 'θ', 'dʒ', 'd', 'ð', 'z', 's', 'ʃ', 's̪', 'dˤ', 't̪', 'ðˤ', 'f', 'q', 'k']

def find_ikhfa_positions(phoneme_list):
    positions = []
    for i in range(len(phoneme_list) - 1):
        if phoneme_list[i] == 'n' and phoneme_list[i+1] in IKHFA_TRIGGERS:
            positions.append((i, 'n', phoneme_list[i+1]))
    return positions

def check_ikhfa_in_detected(ikhfa_positions, expected_seq, detected_seq):
    results = []
    for (noon_pos, noon_ph, trigger_ph) in ikhfa_positions:
        trigger_detected = trigger_ph in detected_seq
        noon_window_start = max(0, noon_pos - 2)
        noon_window_end = min(len(detected_seq), noon_pos + 3)
        window = detected_seq[noon_window_start:noon_window_end]
        noon_nearby = 'n' in window
        if not noon_nearby and trigger_detected:
            results.append({"rule": "ikhfa", "case": "correct",
                "detail": f"Noon sahi chhupa, '{trigger_ph}' detect hua", "tip": None})
        elif noon_nearby and trigger_detected:
            results.append({"rule": "ikhfa", "case": "noon_not_hidden",
                "detail": f"IKHFA rule broken",
                "tip": f"   ن ساکن پر اخفا کریں۔"})
    return results

def ikhfa_feedback(ikhfa_results):
    return [{"rule": r["rule"], "detail": r["detail"], "tip": r["tip"]}
            for r in ikhfa_results if r["case"] != "correct"]

# IZHAR
IZHAR_TRIGGERS = ['ʔ', 'h', 'ʕ', 'ħ', 'ɣ', 'x']

def find_izhar_positions(phoneme_list):
    positions = []
    for i in range(len(phoneme_list) - 1):
        if phoneme_list[i] == 'n' and phoneme_list[i+1] in IZHAR_TRIGGERS:
            positions.append((i, 'n', phoneme_list[i+1]))
    return positions

def check_izhar_in_detected(izhar_positions, expected_seq, detected_seq):
    results = []
    for (noon_pos, noon_ph, trigger_ph) in izhar_positions:
        trigger_detected = trigger_ph in detected_seq
        trigger_index = detected_seq.index(trigger_ph) if trigger_detected else len(detected_seq)
        window = detected_seq[max(0, trigger_index - 3): trigger_index]
        noon_in_window = 'n' in window
        if noon_in_window and trigger_detected:
            results.append({"rule": "izhar", "case": "correct", "detail": "Izhar sahi ada kiya!", "tip": None})
        elif not noon_in_window and trigger_detected:
            results.append({"rule": "izhar", "case": "noon_missing",
                "detail": "IZHAR rule broken",
                "tip": f" حروف حلقی سے پہلے ن کو واضح کر کے پورا ادا کریں ۔"})
    return results

def izhar_feedback(izhar_results):
    return [{"rule": r["rule"], "detail": r["detail"], "tip": r["tip"]}
            for r in izhar_results if r["case"] != "correct"]

# IQLAB
def find_iqlab_positions(phoneme_list):
    positions = []
    for i in range(len(phoneme_list) - 1):
        if phoneme_list[i] in ('n', 'm') and phoneme_list[i+1] == 'b':
            positions.append((i, phoneme_list[i], 'b'))
    return positions

def check_iqlab(iqlab_positions, expected_seq, detected_seq):
    results = []
    for (noon_pos, noon_ph, trigger_ph) in iqlab_positions:
        trigger_detected = trigger_ph in detected_seq
        b_index = detected_seq.index(trigger_ph) if trigger_detected else len(detected_seq)
        window = detected_seq[max(0, b_index - 3): b_index]
        meem_in_window = 'm' in window
        noon_in_window = 'n' in window
        if meem_in_window and not noon_in_window and trigger_detected:
            results.append({"case": "correct", "detail": "Iqlab sahi ada kiya!", "tip": None})
        elif noon_in_window and trigger_detected:
            results.append({"case": "noon_not_converted",
                "detail": "IQLAB rule broken",
                "tip": "ب کو م سے بدل کر اس پر غنہ کریں۔"})
    return results

def iqlab_feedback(iqlab_results):
    return [{"detail": r["detail"], "tip": r["tip"]} for r in iqlab_results if r["case"] != "correct"]

# IDGHAM
def check_idgham_simple(detected_seq):
    results = []
    if len(detected_seq) > 2:
        at_index_2 = detected_seq[2]
        if at_index_2 == 'n':
            results.append({"case": "noon_not_merged",
                "detail": "IDGHAM rule broken.",
                "tip": " شدہ اور اس سے پہلے والے حرف کو اپس میں ضم کر کے پڑھیں۔"})
        elif at_index_2 == 'l':
            results.append({"case": "correct_idgham", "detail": "Idgham sahi ada kiya!", "tip": None})
    return results

def idgham_feedback(idgham_results):
    return [{"detail": r["detail"], "tip": r["tip"]} for r in idgham_results if r["case"] != "correct_idgham"]

# TASHDEED (SHADDA)
def find_tashdid_positions(phoneme_list):
    """Detects Tashdeed targets when an identical consonant is doubled sequentially."""
    positions = []
    for i in range(len(phoneme_list) - 1):
        # Ensure it's a consonant and repeating sequentially
        if phoneme_list[i] == phoneme_list[i+1] and phoneme_list[i] not in ['a', 'i', 'u', 'aː', 'iː', 'uː']:
            positions.append((i, phoneme_list[i]))
    return positions

def check_tashdid_in_detected(tashdeed_positions, expected_seq, detected_seq):
    results = []
    for (exp_index, letter_ph) in tashdeed_positions:
        # Check if the duplicate character string pattern occurs in the relative window
        count = 0
        for i in range(len(detected_seq) - 1):
            if detected_seq[i] == letter_ph and detected_seq[i+1] == letter_ph:
                count += 1
                
        if count >= 1:
            results.append({"rule": "tashdid", "case": "correct", "detail": "Tashdid sahi ada ki!", "tip": None})
        else:
            arabic_letter = PHONEME_TO_ARABIC.get(letter_ph, letter_ph)
            results.append({
                "rule": "tashdid", 
                "case": "tashdid_broken",
                "detail": f"Tashdid rule broken '\n'شدہ والے حرف کو دو بار سختی سے ادا کریں۔",
                "tip": f"شدہ والے حرف کو دو بار سختی سے ادا کریں۔"
            })
    return results

def tashdid_feedback(tashdid_results):
    return [{"rule": r["rule"], "detail": r["detail"], "tip": r["tip"]}
            for r in tashdid_results if r["case"] != "correct"]

# HELPERS
def parse_ipa_string(ipa_str):
    tokens = []
    i = 0
    s = ipa_str.strip()
    while i < len(s):
        if s[i] in ('.', ' '):
            i += 1
            continue
        matched = False
        for token in IPA_TOKENS:
            if s[i:i+len(token)] == token:
                tokens.append(token)
                i += len(token)
                matched = True
                break
        if not matched:
            tokens.append(s[i])
            i += 1
    return tokens

def is_equivalent(ref, detected):
    if ref == detected:
        return True
    for variants in EQUIVALENCE_MAP.values():
        if ref in variants and detected in variants:
            return True
    return False

def normalize_phonemes(phoneme_sequence):
    normalized = []
    i = 0
    while i < len(phoneme_sequence):
        if i + 1 < len(phoneme_sequence) and phoneme_sequence[i] == 's' and phoneme_sequence[i+1] == 'c':
            normalized.append('S')
            i += 2
        elif i + 1 < len(phoneme_sequence) and phoneme_sequence[i] == 't' and phoneme_sequence[i+1] == 'o':
            normalized.append('T')
            i += 2
        else:
            normalized.append(phoneme_sequence[i])
            i += 1
    return normalized

def phoneme_timestamps(predicted_ids, num_frames, audio_len, processor):
    frame_dur = audio_len / num_frames
    vocab_inv = {v: k for k, v in processor.tokenizer.get_vocab().items()}
    blank_id = processor.tokenizer.pad_token_id
    result = []
    cur_id = -1
    seg_start = 0
    for i, tid in enumerate(predicted_ids):
        if tid == blank_id:
            if cur_id not in (-1, blank_id):
                tok = vocab_inv[cur_id].replace("|", "").strip()
                if tok:
                    result.append((tok, seg_start * frame_dur, i * frame_dur))
            cur_id = -1
        elif tid != cur_id:
            if cur_id not in (-1, blank_id):
                tok = vocab_inv[cur_id].replace("|", "").strip()
                if tok:
                    result.append((tok, seg_start * frame_dur, i * frame_dur))
            cur_id = tid
            seg_start = i
    if cur_id not in (-1, blank_id):
        tok = vocab_inv[cur_id].replace("|", "").strip()
        if tok:
            result.append((tok, seg_start * frame_dur, num_frames * frame_dur))
    return result

def compare_full_phoneme_sequence(ref_seq, user_phs):
    feedback = []
    user_set = set(user_phs)
    for ref_ph in ref_seq:
        if any(is_equivalent(ref_ph, d) for d in user_phs):
            continue
        confused_list = CONFUSION_MAP.get(ref_ph, [])
        substitution = next((u for u in user_set if u in confused_list), None)
        if substitution:
            tip = FEEDBACK_RULES.get((ref_ph, substitution))
            ar_exp = PHONEME_TO_ARABIC.get(ref_ph, ref_ph)
            ar_prod = PHONEME_TO_ARABIC.get(substitution, substitution)
            detail = f'Used "{ar_prod}" instead of "{ar_exp}"'
            feedback.append({"detail": detail, "tip": tip if tip else detail})
    return feedback

def calculate_accuracy(rule_ok, phoneme_ok, expected_phonemes, user_ph_list, tajweed_rule):
    is_tajweed_rule = tajweed_rule in (
        "ikhfa", "izhar", "izhaar", "iqlab", "iqlaab",
        "idgham", "idgham_bil_ghunna", "idgham_bila_ghunna", "tashdid"
    )
    if is_tajweed_rule:
        if rule_ok and phoneme_ok:
            return 100.0
        elif not rule_ok and phoneme_ok:
            return 50.0
        elif rule_ok and not phoneme_ok:
            matched = sum(1 for p in expected_phonemes if p in set(user_ph_list))
            ph_acc = (matched / len(expected_phonemes)) * 100 if expected_phonemes else 0
            return round(min(ph_acc, 69.0), 2)
        else:
            matched = sum(1 for p in expected_phonemes if p in set(user_ph_list))
            ph_acc = (matched / len(expected_phonemes)) * 100 if expected_phonemes else 0
            return round(min(ph_acc, 40.0), 2)
    else:
        if phoneme_ok:
            return 100.0
        matched = sum(1 for p in expected_phonemes if p in set(user_ph_list))
        return round((matched / len(expected_phonemes)) * 100, 2) if expected_phonemes else 0.0

# MAIN
def get_tajweed_analysis(audio_path, row, processor):
    audio_len = librosa.get_duration(path=audio_path)
    predicted_ids, num_frames, _ = forced_align(audio_path)

    user_phonemes = phoneme_timestamps(predicted_ids, num_frames, audio_len, processor)
    user_ph_list_raw = [tok for tok, s, e in user_phonemes if (e - s) > 0.01]
    user_ph_list = normalize_phonemes(user_ph_list_raw)

    expected_phonemes = parse_ipa_string(str(row["phenome"]))
    tajweed_rule = str(row["rule"]).strip().lower()

    if tajweed_rule == "ikhfa":
        fb_rule = ikhfa_feedback(check_ikhfa_in_detected(find_ikhfa_positions(expected_phonemes), expected_phonemes, user_ph_list))
    elif tajweed_rule in ("izhar", "izhaar"):
        fb_rule = izhar_feedback(check_izhar_in_detected(find_izhar_positions(expected_phonemes), expected_phonemes, user_ph_list))
    elif tajweed_rule in ("iqlab", "iqlaab"):
        fb_rule = iqlab_feedback(check_iqlab(find_iqlab_positions(expected_phonemes), expected_phonemes, user_ph_list))
    elif tajweed_rule in ("idgham", "idgham_bil_ghunna", "idgham_bila_ghunna"):
        fb_rule = idgham_feedback(check_idgham_simple(user_ph_list))
    elif tajweed_rule == "tashdid":
        fb_rule = tashdid_feedback(check_tashdid_in_detected(find_tashdid_positions(expected_phonemes), expected_phonemes, user_ph_list))
    else:
        fb_rule = []

    fb_phoneme = compare_full_phoneme_sequence(expected_phonemes, user_ph_list)
    rule_ok = len(fb_rule) == 0
    phoneme_ok = len(fb_phoneme) == 0
    accuracy = calculate_accuracy(rule_ok, phoneme_ok, expected_phonemes, user_ph_list, tajweed_rule)

    return accuracy, expected_phonemes, user_ph_list, fb_phoneme, fb_rule