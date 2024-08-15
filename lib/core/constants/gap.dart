/// This class stores all of the sizes used in the app.
enum Gap {
  no(0.0),
  xxxs(0.5),
  xxs(1),
  xs(2),
  s(4),
  m(8),
  l(16),
  xl(32),
  xxl(64),
  xxxl(128);

  final double px;

  const Gap(this.px);
}
