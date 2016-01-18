import Ember from 'ember';

export default Ember.Helper.helper(params => {
  const value = params[0] * 100;
  const dollars = Math.floor(value / 100);
  let cents = value % 100;
  const sign = '$';

  if (cents.toString().length === 1) {
    cents = '0' + cents;
  }
  return `${sign} ${dollars}.${cents}`;
});
