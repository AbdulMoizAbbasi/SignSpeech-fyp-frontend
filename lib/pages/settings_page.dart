import 'package:flutter/material.dart';

import '../app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // --- State Variables (synced with AppSettings) ---
  bool _autoPlay = true;
  double _playbackSpeed = 1.0; // 1.0 is normal speed
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    // load initial values from singleton
    final settings = AppSettings.instance;
    _autoPlay = settings.autoPlay;
    _playbackSpeed = settings.playbackSpeed;
    _fontSize = settings.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. BACKGROUND HEADER (Matches your App Theme)
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
                      "Settings",
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

          // 2. SETTINGS LIST
          Container(
            margin: EdgeInsets.only(top: size.height * 0.20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- SECTION 1: VIDEO & PLAYBACK ---
                  _buildSectionHeader("Video Preferences"),
                  _buildCard(
                    children: [
                      // Playback Speed Slider
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Playback Speed",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${_playbackSpeed}x",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF01579B),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _playbackSpeed,
                              min: 0.5,
                              max: 2.0,
                              divisions: 3, // 0.5, 1.0, 1.5, 2.0
                              activeColor: const Color(0xFF00BCD4),
                              inactiveColor: Colors.grey[300],
                              onChanged: (val) {
                                setState(() => _playbackSpeed = val);
                                AppSettings.instance.updatePlaybackSpeed(val);
                              },
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Slow (0.5x)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "Fast (2.0x)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Auto Play Toggle
                      SwitchListTile(
                        activeColor: const Color(0xFF00BCD4),
                        title: const Text(
                          "Auto-Play Videos",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          "Play videos automatically when loaded",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        value: _autoPlay,
                        onChanged: (val) {
                          setState(() => _autoPlay = val);
                          AppSettings.instance.updateAutoPlay(val);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- SECTION 2: TEXT SIZE ---
                  _buildSectionHeader("Text Size"),
                  _buildCard(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Text Size Preview",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Preview Text",
                                style: TextStyle(
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() {
                                    if (_fontSize > 12) {
                                      _fontSize--;
                                      AppSettings.instance.updateFontSize(
                                        _fontSize,
                                      );
                                    }
                                  }),
                                ),
                                Text(
                                  "${_fontSize.toInt()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFF00BCD4),
                                  ),
                                  onPressed: () => setState(() {
                                    if (_fontSize < 24) {
                                      _fontSize++;
                                      AppSettings.instance.updateFontSize(
                                        _fontSize,
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- SECTION 3: ACCOUNT & PRIVACY ---
                  _buildSectionHeader("Account"),
                  _buildCard(
                    children: [
                      _buildClickableTile(
                        Icons.lock_outline,
                        "Change Password",
                        () {},
                      ),
                      const Divider(height: 1),
                      _buildClickableTile(
                        Icons.info_outline,
                        "About SignSpeech",
                        () {
                          showAboutDialog(
                            context: context,
                            applicationName: "SignSpeech",
                            applicationVersion: "1.0.0",
                            applicationIcon: Image.asset(
                              "assets/logo.png",
                              width: 50,
                              height: 50,
                            ),
                            children: [
                              const Text("Translating voice to sign language."),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets for Clean Code ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildClickableTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFFE0F7FA),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF00BCD4),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
