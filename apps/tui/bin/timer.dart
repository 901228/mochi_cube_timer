import "package:nocterm/nocterm.dart";

// class Timer extends StatelessComponent {
//   const Timer({super.key});

//   @override
//   Component build(BuildContext context) {
//     return Focusable(
//       focused: true,
//       onKeyEvent: (event) {
//         return false;
//       },
//       child: Center(child: AsciiText("Count: 0")),
//     );
//   }
// }

/// Demo showcasing the AsciiText component with various fonts and styles.
class Timer extends StatelessComponent {
  const Timer();

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKey.keyQ) {}
        return false;
      },
      child: Column(
        children: [
          Container(
            child: AsciiText(
              "123:45",
              font: .block,
              textAlign: .center,
              style: TextStyle(color: Colors.black),
            ),
          ),

          // Footer
          Container(
            color: const Color.fromRGB(40, 40, 60),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                const Text("Tab/←→: Switch Protocol  ", style: TextStyle(color: Colors.grey)),
                const Text("1-4: Direct Select  ", style: TextStyle(color: Colors.grey)),
                const Text("↑↓: Scroll  ", style: TextStyle(color: Colors.grey)),
                const Text("Q: Quit", style: TextStyle(color: Colors.grey)),
                const Spacer(),
                Text("Current: protocol", style: const TextStyle(color: Colors.cyan)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
