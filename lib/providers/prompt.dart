import 'package:flutter/material.dart';
import 'package:omni_chat/apis/prompt/get_list.dart';
import 'package:omni_chat/models/api/prompt/prompt_list_res.dart';
import 'package:omni_chat/models/prompt.dart';

class PromptProvider extends ChangeNotifier {
  List<Prompt> publicPrompts;
  List<Prompt> privatePrompts;
  List<Prompt> slashPrompts;
  String query = "";
  String filteredCategory = "";
  bool favFiltered = false;

  PromptProvider({
    this.publicPrompts = const [],
    this.privatePrompts = const [],
    this.slashPrompts = const [],
  });

  Future<void> loadList({required bool isPublic}) async {
    PromptListResponse? promptListResponse = await getPromptList(
      isFavorite: favFiltered,
      isPublic: isPublic,
      query: query,
      category: filteredCategory,
    );
    if (promptListResponse != null) {
      if (isPublic) {
        publicPrompts = promptListResponse.items;
      } else {
        privatePrompts = promptListResponse.items;
      }
    }
    notifyListeners();
  }

  bool isListEmpty({required bool isPublic}) {
    if (isPublic) {
      return publicPrompts.isEmpty;
    } else {
      return privatePrompts.isEmpty;
    }
  }

  void load2List() {
    loadList(isPublic: true);
    loadList(isPublic: false);
  }

  void toggleFavoriteFilter() {
    favFiltered = !favFiltered;
    load2List();
  }

  void setFilteredCategory(String category) {
    filteredCategory = category;
    loadList(isPublic: true);
  }

  void searchPrompt(String queryStr) {
    query = queryStr;
    load2List();
  }

  void initPromptLibrary() {
    publicPrompts = [];
    privatePrompts = [];
    query = "";
    filteredCategory = "";
    favFiltered = false;
    load2List();
  }

  Future<void> loadSlashList() async {
    await loadList(isPublic: true);
    await loadList(isPublic: false);
    slashPrompts = [...publicPrompts, ...privatePrompts];
    notifyListeners();
  }
}
