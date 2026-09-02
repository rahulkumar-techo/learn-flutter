import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            toolbarHeight: 50,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://images.unsplash.com/photo-1674027392887-751d6396b710?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                fit: BoxFit.cover,
              ),

              title: Text(
                "Meeo Shopping Platform",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SliverAppBar(
            expandedHeight: 200,
            toolbarHeight: 150,
            // snap: true,
            backgroundColor: Colors.deepPurple,
            centerTitle: false,

            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              title: const Text(
                'Current Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              background: const SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 60,
                      child: Text(
                        '\$5,00,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),
          ),

          SliverFillRemaining(),
        ],
      ),
    );
  }
}
