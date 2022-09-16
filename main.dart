void main() {
  const foo = Foo(1);
  const bar = Foo(2);
  const baz = bar;
  print(baz);
}

class Foo {
  const Foo(this._foo);
  final int _foo;
}
