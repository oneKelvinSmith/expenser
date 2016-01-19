import Ember from 'ember';

export default Ember.Helper.helper(params => {
  const value = Number(params[0]).toFixed(2);
  const sign = '$';

  return `${sign} ${value}`;
});
