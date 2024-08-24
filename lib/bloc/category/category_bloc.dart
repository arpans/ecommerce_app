import 'package:ecommerce_app/bloc/category/category_event.dart';
import 'package:ecommerce_app/bloc/category/category_state.dart';
import 'package:ecommerce_app/repositories/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());

    try {
      final categories = await categoryRepository.fetchCategories();
      if (categories.isNotEmpty) {
        // Automatically select the first category
        emit(CategoryLoaded(categories, selectedCategory: categories[0]));
      } else {
        emit(CategoryLoaded(categories));
      }
    } catch (e) {
      emit(CategoryError("Failed to load categories"));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoryLoaded) {
      final loadedState = state as CategoryLoaded;
      emit(
        CategoryLoaded(loadedState.categories,
            selectedCategory: event.category),
      );
    }
  }
}
