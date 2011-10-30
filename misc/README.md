KURO-RS Ruby
============
Buffaloの学習リモコン KURO-RSを操作する


Requirement
-----------

* Ruby 1.8.7
* [KURO-RS](http://www.kuroutoshikou.com/modules/display/?iid=928) or [PC-OP-RS1](http://buffalo.jp/products/catalog/item/p/pc-op-rs1/)


Install Dependencies
--------------------

    % gem install serialport


Read
----

    % ruby kuro-rs-read.rb /dev/tty.usbserial-00002e6e
    # => hex dump (ffffffff0300f0e0018083...)


Write
-----

    % ruby kuro-rs-write.rb /dev/tty.usbserial-00002e6e ffffffff0300f0e0018083...
