import 'package:restaurance/OrderScreens/Menu.dart';

class OrderRow
{
  Menu menu;
  int count;

  OrderRow(Menu menu, int count)
  {
    this.menu = menu;
    this.count = count;
  }
}