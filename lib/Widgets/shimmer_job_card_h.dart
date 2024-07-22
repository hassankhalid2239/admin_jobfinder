import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerJobCardH extends StatelessWidget {
  const ShimmerJobCardH({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
          width: 202,
          height: 240,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: FadeShimmer.round(
                    size: 40,
                    highlightColor: const Color(0xff798ea5c0),
                    baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FadeShimmer(
                  height: 10,
                  width: 100,
                  radius: 10,
                  highlightColor: const Color(0xff798ea5c0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                const SizedBox(
                  height: 15,
                ),
                FadeShimmer(
                  height: 10,
                  width: 150,
                  radius: 10,
                  highlightColor: const Color(0xff798ea5c0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                const SizedBox(
                  height: 15,
                ),
                FadeShimmer(
                  height: 10,
                  width: 50,
                  radius: 10,
                  highlightColor: const Color(0xff798ea5c0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                const SizedBox(
                  height: 15,
                ),
                FadeShimmer(
                  height: 28,
                  width: 70,
                  radius: 8,
                  highlightColor: const Color(0xff798ea5c0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: FadeShimmer(
                    height: 10,
                    width: 60,
                    radius: 10,
                    highlightColor: const Color(0xff798ea5c0),
                    baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  trailing: FadeShimmer(
                    width: 70,
                    height: 30,
                    radius: 12,
                    highlightColor: const Color(0xff798ea5c0),
                    baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}




















// import 'package:fade_shimmer/fade_shimmer.dart';
// import 'package:flutter/material.dart';
//
// class ShimmerJobCardH extends StatelessWidget {
//   const ShimmerJobCardH({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: Container(
//           width: 202,
//           height: 240,
//           decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.tertiaryContainer,
//               borderRadius: BorderRadius.circular(8)),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: FadeShimmer.round(
//                     size: 40,
//                     highlightColor: const Color(0xff798ea5c0),
//                     baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 FadeShimmer(
//                   height: 10,
//                   width: 100,
//                   radius: 10,
//                   highlightColor: const Color(0xff798ea5c0),
//                   baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 FadeShimmer(
//                   height: 10,
//                   width: 150,
//                   radius: 10,
//                   highlightColor: const Color(0xff798ea5c0),
//                   baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 FadeShimmer(
//                   height: 10,
//                   width: 50,
//                   radius: 10,
//                   highlightColor: const Color(0xff798ea5c0),
//                   baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 FadeShimmer(
//                   height: 28,
//                   width: 70,
//                   radius: 8,
//                   highlightColor: const Color(0xff798ea5c0),
//                   baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: FadeShimmer(
//                     height: 10,
//                     width: 60,
//                     radius: 10,
//                     highlightColor: const Color(0xff798ea5c0),
//                     baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                   ),
//                   trailing: FadeShimmer(
//                     width: 70,
//                     height: 30,
//                     radius: 12,
//                     highlightColor: const Color(0xff798ea5c0),
//                     baseColor: Theme.of(context).colorScheme.tertiaryContainer,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }
