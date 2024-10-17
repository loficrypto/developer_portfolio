import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Developer Portfolio',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  final List<String> skills = ["JavaScript", "React", "Next.js", "Tailwind CSS", "Dart", "Flutter", "Python", "Node.js"];
  List repos = [];

  @override
  void initState() {
    super.initState();
    fetchRepos();
  }

  void sendEmail() {
    EmailJS.send(
      'YOUR_SERVICE_ID',
      'YOUR_TEMPLATE_ID',
      {
        'from_name': nameController.text,
        'reply_to': emailController.text,
        'message': messageController.text,
      },
      'YOUR_USER_ID',
    ).then((response) {
      print('SUCCESS!');
    }).catchError((error) {
      print('FAILED...');
    });
  }

  void fetchRepos() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/YOUR_USERNAME/repos'));
    if (response.statusCode == 200) {
      setState(() {
        repos = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Developer Portfolio')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About Section
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("About Me", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("I am a passionate developer with experience in building responsive and dynamic web applications.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Skills Section
              AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Skills", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: skills.map((skill) => Chip(label: Text(skill))).toList(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Projects Section
              AnimationConfiguration.staggeredList(
                position: 2,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Projects", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        ...repos.map((repo) => Card(
                          child: ListTile(
                            title: Text(repo['name'], style: TextStyle(color: Colors.blue)),
                            subtitle: Text(repo['description'] ?? 'No description'),
                            onTap: () => launch(repo['html_url']),
                          ),
                        )).toList(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Contact Section
              AnimationConfiguration.staggeredList(
                position: 3,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Contact Me", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: 'Your Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Your Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(labelText: 'Your Message'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your message';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    sendEmail();
                                  }
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
