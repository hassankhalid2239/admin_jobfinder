import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerJobCard extends StatelessWidget {
  const ShimmerJobCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 107,
        child: Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: FadeShimmer.round(
                  size: 50,
                  highlightColor: const Color(0xff798EA5C0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                title: FadeShimmer(
                  height: 15,
                  width: 100,
                  radius: 10,
                  highlightColor: const Color(0xff798EA5C0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                subtitle: FadeShimmer(
                  height: 10,
                  width: 100,
                  radius: 10,
                  highlightColor: const Color(0xff798EA5C0),
                  baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    FadeShimmer.round(
                      size: 10,
                      highlightColor: const Color(0xff798EA5C0),
                      baseColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    FadeShimmer(
                      height: 10,
                      width: 120,
                      radius: 10,
                      highlightColor: const Color(0xff798EA5C0),
                      baseColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FadeShimmer.round(
                      size: 10,
                      highlightColor: const Color(0xff798EA5C0),
                      baseColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    FadeShimmer(
                      height: 10,
                      width: 100,
                      radius: 10,
                      highlightColor: const Color(0xff798EA5C0),
                      baseColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
