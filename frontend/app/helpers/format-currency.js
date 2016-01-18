import Ember from 'ember';

export default Ember.Helper.helper(params => {
  const value = String(params[0]);
  const sign = '$';

  return `${sign} ${value}`;
});
