import 'package:flutter/material.dart';
import 'learn_screen.dart';
import 'practise_screen.dart';
import 'makharij.dart';

class ModeScreen extends StatefulWidget {
  const ModeScreen({super.key});

  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  static const Color darkGreen = Color(0xFF4A6858);
  static const Color bgColor = Color(0xFFECE9D0);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // ===== SIDE DRAWER =====
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Drawer Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                color: darkGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "AL-MAKHARIJ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: bgColor,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "AI Powered Tajweed App",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Privacy Policy
              _drawerItem(
                icon: Icons.privacy_tip_outlined,
                label: "Privacy Policy",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                  );
                },
              ),

              _drawerDivider(),

              // About Application
              _drawerItem(
                icon: Icons.info_outline,
                label: "About Application",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),

              _drawerDivider(),

              // User Guide
              _drawerItem(
                icon: Icons.menu_book_outlined,
                label: "User Guide",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserGuideScreen()),
                  );
                },
              ),

              _drawerDivider(),

              const Spacer(),

              // Version tag at bottom
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          // ===== BEIGE BOX EDGE TO EDGE =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFFECE9D0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(1, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // ===== SCROLLABLE CONTENT =====
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // ===== MENU ICON TOP LEFT =====
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _menuBar(width: 26),
                          const SizedBox(height: 5),
                          _menuBar(width: 18),
                          const SizedBox(height: 5),
                          _menuBar(width: 22),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),

                  const Text(
                    "!اهلاً و سهلاً",
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: "Arabic",
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ===== APP BANNER CARD =====
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 6),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8,
                            top: 8,
                            bottom: 8,
                            width: MediaQuery.of(context).size.width * 0.47,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F2EA).withOpacity(0.30),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "AL-MAKHARIJ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'English',
                                      fontWeight: FontWeight.normal,
                                      color: bgColor,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Bridging the gap between Traditional Learning and AI Based Evaluation.",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                      fontFamily: 'English',
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Image.asset(
                                'assets/images/koran_384372.png',
                                width: 95,
                                height: 95,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),

                  // ===== HADITH TEXT =====
                  const Text(
                    "خَيْرُكُم مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Arabic",
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '"The best of you are those who learn\n the Qur\'an and teach it."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Urdu',
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 90),

                  // ===== THREE CARD BUTTONS =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _modeCard(
                        context,
                        assetPath: "assets/images/lessons_icons.png",
                        label: "Lessons",
                        subLabel: "اسباق",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const LearnAllLessonsScreen())),
                      ),
                      _modeCard(
                        context,
                        assetPath: "assets/images/practice_icon.png",
                        label: "Practice",
                        subLabel: "مشق",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const PracticeListScreen())),
                      ),
                      _modeCard(
                        context,
                        assetPath: "assets/images/makharij_icon.png",
                        label: "Makharij",
                        subLabel: "مخارج",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const MakharijScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== MENU BAR LINES =====
  Widget _menuBar({required double width}) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ===== DRAWER ITEM =====
  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: darkGreen, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  // ===== DRAWER DIVIDER =====
  Widget _drawerDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 24,
      endIndent: 24,
      color: Colors.black12,
    );
  }

  Widget _modeCard(
      BuildContext context, {
        required String assetPath,
        required String label,
        required String subLabel,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 140,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: 96,
                height: 130,
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(2, 3),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: bgColor,
                        fontFamily: 'Urdu',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      subLabel,
                      style: const TextStyle(
                        color: bgColor,
                        fontSize: 23,
                        fontFamily: "Urdu",
                      ),
                    ),
                    const SizedBox(height: 27),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Image.asset(
                assetPath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== PRIVACY POLICY SCREEN =====
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color bgColor = Color(0xFFECE9D0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PRIVACY POLICY",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Data Collection"),
            _sectionBody(
              "AL-MAKHARIJ collects audio recordings solely for the purpose of Tajweed evaluation. No personal data is stored on external servers beyond the session.",
            ),
            const SizedBox(height: 20),
            _sectionTitle("Audio Usage"),
            _sectionBody(
              "Audio recordings are processed by our AI model for pronunciation feedback and are not shared with any third parties.",
            ),
            const SizedBox(height: 20),
            _sectionTitle("User Rights"),
            _sectionBody(
              "Users have the right to stop recording at any time. No account or personal information is required to use this application.",
            ),
            const SizedBox(height: 20),
            _sectionTitle("Contact"),
            _sectionBody(
              "For any privacy-related concerns, please reach out to us via the support email provided on our website.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: darkGreen,
      ),
    );
  }

  Widget _sectionBody(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          height: 1.7,
        ),
      ),
    );
  }
}

// ===== ABOUT SCREEN =====
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color bgColor = Color(0xFFECE9D0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ABOUT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/koran_384372.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "AL-MAKHARIJ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkGreen,
                fontFamily: "English",
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Version 1.0.0",
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "AL-MAKHARIJ is an AI-powered Tajweed learning application designed to bridge the gap between traditional Quranic learning and modern AI model evaluation.\n\nThe app helps users practice and improve their Arabic letter pronunciation (Makharij) with real-time feedback powered by machine learning.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Developed with ❤️ for the Ummah",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black38,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== USER GUIDE SCREEN =====
class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color bgColor = Color(0xFFECE9D0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "USER GUIDE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _guideStep("1", "Listen to the Word",
                "Tap on the word card to hear the correct pronunciation of each Arabic word."),
            _guideStep("2", "Start Recording",
                "Press the Record button and recite the word clearly into your microphone."),
            _guideStep("3", "Stop & Analyse",
                "Press Stop when done. The AI will analyse your pronunciation and provide Tajweed feedback."),
            _guideStep("4", "Read the Feedback",
                "Review your accuracy score, phonetic errors, and Tajweed rule violations in the feedback panel."),
            _guideStep("5", "Navigate Words",
                "Use the Previous and Next buttons to move between words and continue practising."),
            _guideStep("6", "Explore Makharij",
                "Visit the Makharij section to learn about the articulation points of Arabic letters."),
            _guideStep("7", "Phonetic Feedback",
                "Phonetic feedback evaluates the errros which can occur in pronouncing the identical letters."
                    "Every Letter has its own point of articulation which must be kept in mind."
                     "FOR EXAMPLE : if a user says ک instead of  ق ,the phonetic feedback highlights the error."),
            _guideStep("8", "Tajweed Feedback",
                "Tajweed Feedback evaluates the errors which can occur if any of the tajweed rule is broken.For now we have only implemented a few rules as a test system.FOR EXAMPLE"
                    ": if a user properly says the ن before huruf e halqi, he violates the IZHAR rule, So system will highlight this error."),
          ],
        ),
      ),
    );
  }

  Widget _guideStep(String number, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: darkGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}