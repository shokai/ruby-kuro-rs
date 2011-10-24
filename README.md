KURO-RS Ruby
============
Buffaloの学習リモコン KURO-RSを操作する


Read
----

    % ruby kuro-rs-read.rb /dev/tty.usbserial-00002e6e
    # => hex dump (ffffffff0300f0e0018083...)


Write
-----

    % ruby kuro-rs-write.rb /dev/tty.usbserial-00002e6e ffffffff0300f0e0018083...
