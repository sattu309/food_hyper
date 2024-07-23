import 'package:flutter/material.dart';

import '../../../components/rounded_icon_btn.dart';
import '../../../constants.dart';
import '../../../helper/heigh_width.dart';
import '../../../models/Cart.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int counter = 1;
  increseCounter(){
    counter++;
    setState(() {});
  }
  decreaseCounter(){
    counter--;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return
      Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(widget.cart.product.images[0]),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cart.product.title,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: "\$${widget.cart.product.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                    // children: [
                    //   TextSpan(
                    //       text: " x${widget.cart.numOfItem}",
                    //       style: Theme.of(context).textTheme.bodyLarge),
                    // ],
                  ),
                ),
                addWidth(20),
                RoundedIconBtn(
                  icon: Icons.remove,
                  press: () {
                    decreaseCounter();
                  },
                ),
                const SizedBox(width: 15),
                Text(
                  counter.toString(),style:Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(width: 15),
                RoundedIconBtn(
                  icon: Icons.add,
                  showShadow: true,
                  press: () {
                    increseCounter();
                  },
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
