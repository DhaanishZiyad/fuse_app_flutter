import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  // Simulated cart items (these can be hardcoded for illustration purposes)
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'FUSE X CSK',
      'imagePath': 'images/test_post.png',
      'currentPrice': 2950.00,
      'quantity': 1,
    },
    {
      'name': 'FUSE X BMS',
      'imagePath': 'images/test_post2.png',
      'currentPrice': 2950.00,
      'quantity': 2,
    },
  ];

  Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Set a maximum width for each card
              double cardMaxWidth = 700;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          'Cart',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // Cart items section
                  ...cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: cardMaxWidth, // Apply max width for the card
                          ),
                          child: Card(
                            child: ListTile(
                              leading: Image.asset(
                                item['imagePath'],
                                width: 50,
                                height: 50,
                              ),
                              title: Text(item['name']),
                              subtitle: Text('LKR. ${item['currentPrice']}'),
                              trailing: Text(
                                'QTY: ${item['quantity']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Button background color (use `backgroundColor` instead of `primary`)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding inside the button
                          ),
                          child: const Text(
                            'Check Out',
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                          onPressed: () {
                            // Add your onPressed action here
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
