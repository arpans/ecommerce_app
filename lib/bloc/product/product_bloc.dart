import 'package:ecommerce_app/bloc/product/product_event.dart';
import 'package:ecommerce_app/bloc/product/product_state.dart';
import 'package:ecommerce_app/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    try {
      final products = await productRepository.fetchProductsByCategory(event.category);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(const ProductError("Failed to load products"));
    }
  }
}

