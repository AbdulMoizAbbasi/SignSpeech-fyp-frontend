import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // 1. BACKGROUND HEADER
          Container(
            height: size.height * 0.25,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BCD4), Color(0xFF01579B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Back Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // Title
                  const Center(
                    child: Text(
                      "How to Use",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. INSTRUCTIONS LIST
          Container(
            margin: EdgeInsets.only(top: size.height * 0.20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildInstructionCard(
                    number: "1",
                    title: "Select Language",
                    description:
                        "Choose your preferred language mode at the bottom of the screen:\n• PSL (Pakistani Sign Language)\n• ASL (American Sign Language)",
                    icon: Icons.language,
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionCard(
                    number: "2",
                    title: "Input Text",
                    description:
                        "You can input text in two ways:\n• Type directly in the text field\n• Use the microphone button to speak and transcribe",
                    icon: Icons.keyboard,
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionCard(
                    number: "3",
                    title: "Generate Video",
                    description:
                        "Tap the send button (circular button on the right) to generate a sign language video based on your text.",
                    icon: Icons.videocam,
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionCard(
                    number: "4",
                    title: "Play & Download",
                    description:
                        "Watch the generated video using the built-in player. Use the download button to save videos to your device.",
                    icon: Icons.download,
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionCard(
                    number: "5",
                    title: "Adjust Settings",
                    description:
                        "Open Settings from the profile menu to:\n• Control auto-play\n• Adjust playback speed\n• Change text size",
                    icon: Icons.settings,
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionCard(
                    number: "6",
                    title: "Manage Profile",
                    description:
                        "Edit your profile information (name, gender, birth year) from the Edit Profile option in the menu.",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 40),
                  // Tips Section
                  _buildTipsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number Circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00BCD4), Color(0xFF01579B)],
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 24),
              const SizedBox(width: 10),
              Text(
                "Tips & Tricks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip(
            "Clear speech input: Speak slowly and clearly for better transcription",
          ),
          _buildTip(
            "Language consistency: Keep text in the selected language mode",
          ),
          _buildTip(
            "Playback speed: Adjust speed in settings for better comprehension",
          ),
          _buildTip(
            "Auto-play: Enable auto-play in settings to view videos automatically",
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber[700],
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
