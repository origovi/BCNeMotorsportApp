// Draws the grid used to represent each section
import 'package:bcnemotorsportapp/models/team/SectionsData.dart';
import 'package:bcnemotorsportapp/widgets/team/SectionCard.dart';
import 'package:flutter/material.dart';

class SectionGrid extends StatelessWidget {
  final SectionsData _data;
  final List<String> _desiredSections;
  final bool _shrinkWrap;
  final ScrollController _controller;
  final EdgeInsets _padding;

  SectionGrid(
      {@required SectionsData data,
      List<String> desiredSections,
      bool shrinkWrap = false,
      ScrollController controller,
      EdgeInsets padding = const EdgeInsets.all(0)})
      : _data = data,
        _desiredSections = desiredSections,
        _shrinkWrap = shrinkWrap,
        _controller = controller,
        _padding = padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _controller ?? ScrollController(),
      shrinkWrap: _shrinkWrap,
      padding: _padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _desiredSections == null ? _data.size : _desiredSections.length,
      itemBuilder: _desiredSections == null
          ? (context, index) {
              return SectionCard(_data.sectionByIndex(index));
            }
          : (context, index) {
              return SectionCard(_data.sectionById(_desiredSections[index]));
            },
    );
  }
}
