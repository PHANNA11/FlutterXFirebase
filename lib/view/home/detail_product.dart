import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../model/product_model.dart';

class DetailProduct extends StatefulWidget {
  DetailProduct({super.key, this.productModel});
  ProductModel? productModel;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productModel!.name!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: widget.productModel!.code!,
            child: Image(
              width: double.infinity,
              fit: BoxFit.cover,
              image: NetworkImage(widget.productModel!.image!),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text(
                    'varraint Colors :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: List.generate(
                      widget.productModel!.varriants!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          maxRadius: 12,
                          backgroundColor: HexColor(widget
                              .productModel!.varriants![index]
                              .toString()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '\$ ${widget.productModel!.price}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 18),
              ),
            ],
          ),
          Text(widget.productModel!.description!)
        ],
      ),
    );
  }
}
