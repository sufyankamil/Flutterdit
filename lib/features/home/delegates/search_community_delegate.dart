import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../community/controller/community_controller.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) {
            return ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    navigateToCommunity(context, communities[index].name);
                    close(context, '');
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(communities[index].avatar),
                  ),
                  title: Text(communities[index].name),
                  subtitle: Text(communities[index].description),
                );
                return null;
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
        );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    // Navigator.of(context).pushNamed('/community/$name');
    Routemaster.of(context).push('/$communityName');
  }
}
