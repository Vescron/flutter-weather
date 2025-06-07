import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/pages/weather_page.dart';
import 'package:weather/pages/other_days.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(
    initialPage: 0,
    keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children:[
          Expanded(
            child: PageView(
              controller: controller ,
              children: const [WeatherPage(),OtherDaysPage()],),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SmoothPageIndicator(    
                  controller: controller,  // PageController    
                  count:  2,    
                  effect:  SwapEffect(
                    dotHeight: 20,    
                    dotWidth: 20,    
                    spacing: 16,    
                    activeDotColor: Theme.of(context).colorScheme.primary,    
                    dotColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),  // your preferred effect    
                  onDotClicked: (index){    
                    controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
          ) 
          // You can add your SmoothPageIndicator here if needed
        ]
      ),
    );
  }
}