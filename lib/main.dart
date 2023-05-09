import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Application());
}

class Application extends StatefulWidget {
  Application({super.key});

  @override
  State<Application> createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  late SupabaseClient supabase;
  bool initializing = true;

  @override
  initState() {
    () async {
      supabase = (await Supabase.initialize(
        url: 'https://xuddclpbstoywvazbkbf.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1ZGRjbHBic3RveXd2YXpia2JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDY2NDI1NzcsImV4cCI6MTk2MjIxODU3N30.0n1N3LqZmek3m3yv5M3lGICHczi8NjZBy1sl6S4StXM',
      ))
          .client;
      setState(() {
        initializing = false;
      });
    }();
  }

  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime',
      home: initializing ? Splash() : Main(supabase),
    );
  }
}

class Splash extends StatelessWidget {
  Splash({super.key});

  @override
  build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'initializing...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class Main extends StatefulWidget {
  final SupabaseClient supabase;
  late RealtimeChannel channel;
  Main(this.supabase, {super.key}) {
    channel = supabase.channel('realtime');
    channel.onEvents(
      'event',
      ChannelFilter(),
      (payload, [ref]) {
        debugPrint('callback: ${payload.toString()}');
      },
    );
    channel.subscribe();
    debugPrint('subscribed');
  }

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  @override
  build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: TextButton(
          onPressed: () {
            debugPrint('foobar clicked, broadcasting event');
            widget.channel.send(
              'event',
              {
                'foo': 'bar',
              },
            );
          },
          child: const Text(
            'Foobar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
