import 'package:dairy/format/color_palette.dart';
import 'package:dairy/widgets/pageAnimation.dart';
import 'package:flutter/material.dart';
import 'package:dairy/global_var.dart';
import 'package:readmore/readmore.dart';

import '../widgets/bigImage.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List str=['''Imagine the evolution of programming languages as the growth of a vast and diverse forest. In this forest, each programming language is like a unique species of tree, adapted to different environmental conditions and purposes.

- Early Roots (Pre-20th Century): In the beginning, the forest was sparse, with only a few simple trees. These were the early forms of machine code and assembly languages, akin to the most basic and hardy plants that could survive in the harshest conditions. Programmers had to work directly with the raw elements of the forest, much like early humans had to adapt to nature's challenges.

- The Emergence of High-Level Languages (Mid-20th Century): As time passed, programmers developed high-level languages like FORTRAN, COBOL, and Lisp. These were like the first cultivated trees in the forest, carefully bred and shaped for specific tasks. They made it easier for humans to communicate with the forest, like grafting branches onto existing trees to bear more fruit.

- The Diversification (Late 20th Century): In the latter part of the century, the forest flourished with diversity. Languages like C, C++, and Java grew tall and strong, each specializing in different areas of application development. It was as if the forest had different regions, each with its own unique ecosystem of languages.

- The Modern Era (21st Century): In the modern era, the forest became a lush jungle. New languages like Python, JavaScript, and Ruby emerged as agile and versatile species, thriving in the rapidly changing environment. These languages were like adaptable vines, able to climb and interact with the canopy above and the undergrowth below.

- Specialization and Niche Languages (Contemporary): Today, the forest is not just one but a multitude of ecosystems, each with its own set of specialized trees. Languages like Rust, Go, and Swift are like rare and valuable plants in specialized microclimates, perfectly suited for specific tasks and niches.

- The Future Growth: The forest continues to evolve. Just as new species of trees constantly emerge in nature, new programming languages will continue to be developed to address the ever-changing needs of technology. It's an ongoing cycle of growth, adaptation, and innovation in the forest of programming languages 
    ''',
  '''Imagine the evolution of communication as a journey through diverse landscapes, each representing a different era in human history.

- The Cave Paintings (Prehistoric Era): In the earliest days of human existence, communication was like cave paintings. People used simple drawings and symbols to convey their thoughts and experiences.

- The Village Square (Ancient Civilizations): As human societies formed, communication became akin to a bustling village square. People gathered to share stories, news, and ideas through spoken words, gestures, and simple written symbols. This was the age of oral traditions and the birth of written languages.

- The Silk Road (Medieval and Renaissance Periods): With the growth of civilizations and trade routes, communication evolved into a vast network of interconnected pathways. People exchanged not only goods but also knowledge, languages, and cultures.

- The Telegraph and Postal System (Industrial Revolution): The Industrial Revolution brought about the telegraph and postal systems, likened to a network of railways and highways. Messages and letters traveled faster and farther than ever before, much like the speed and reach of transportation systems connecting distant regions.

- The Radio and Television Era (20th Century): The 20th century ushered in an era of mass communication, comparable to broadcasting towers and television screens. Radio and television brought news and entertainment directly into people's homes, much like the way signals and broadcasts reached across vast distances.

- The Internet (Digital Age): The internet revolutionized communication by creating a global information superhighway. It's akin to a digital realm where people can instantly connect, share, and access information worldwide. It's as if the entire world became one interconnected, virtual space where ideas and data flow seamlessly.

- The Social Media Landscape (Contemporary): Today, communication is like a vast and dynamic social media landscape. Social platforms are like bustling metropolises of thoughts and connections, where people share their lives, opinions, and experiences on a global scale. It's akin to a digital cityscape that never sleeps.

- The Future (Emerging Technologies): Looking ahead, communication will continue to evolve, much like a journey through uncharted territory. Emerging technologies like virtual reality, augmented reality, and advanced AI promise to reshape how we connect and communicate, opening up new frontiers of human interaction and expression.''',
    '''This app provides a way to allow crowd-sourcing data from the public with the help of Google cloud. This means that people would provide the details of the incident from the place where it has occurred through this app and it would alert the authorities of the issue. This app comes equipped with location detection and other features which would let the user specify the details of the incident.
    I hope you like our app!!
    '''
  ];
  List titles=["The journey of programming languages","The evolution of communication","Purpose of this app"];
  Appstyle AppStyle=Appstyle();
  bool isReadMore=false;
  @override
  Widget build(BuildContext context) {
    global_var.context=context;

    return ListView(
          shrinkWrap: true,
          children: [
            Text(""),
            Tile(titles[2],str[2]),
            Tile(titles[0],str[0]),
            Tile(titles[1],str[1]),


          ],
    );
  }

  Tile(title,str) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppStyle.bodyColor,
          boxShadow: [
            BoxShadow(
              color:AppStyle.contentColor,
              blurRadius: 10,
            )
          ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
            vertical: global_var.height * 0.06,
            horizontal: global_var.width * 0.11),
        margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),

        child: Column(
          children: [
            Text(title,textAlign: TextAlign.center,style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(height: 10,),
            buildText(str),
            SizedBox(height: 10,),
            Container(
              child: title==titles[0]?GestureDetector(onTap:(){Navigator.push(context, pageAnimation().getAnimation(bigImage()));},child: Image.asset("assets/images/prog.jpg")):null,
            )
          ],
        ),


      ),
    );
  }
  buildText(str){
    return ReadMoreText(
      str,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15
      ),
    );
  }

}
