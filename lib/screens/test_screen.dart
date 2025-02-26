import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/actions/bla_button.dart';

class TestBlaButtonScreen extends StatelessWidget {
  const TestBlaButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test BlaButton'),
      ),
      body: Padding(
        padding: EdgeInsets.all(BlaSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlaButton(
              label: 'Primary Button',
              onPressed: () => print('Primary Button Pressed'),
              type: 'primary',
            ),
            SizedBox(height: BlaSpacings.m),
            BlaButton(
              label: 'Secondary Button',
              onPressed: () => print('Secondary Button Pressed'),
              type: 'secondary', 
            ),
            SizedBox(height: BlaSpacings.m),
            BlaButton(
              label: 'Primary Button with Icon',
              onPressed: () => print('Primary Button with Icon Pressed'),
              type: 'primary',
              icon: Icons.check, 
            ),
            SizedBox(height: BlaSpacings.m),
            BlaButton(
              label: 'Disabled Button',
              onPressed: null, 
              type: 'primary',
              disabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
