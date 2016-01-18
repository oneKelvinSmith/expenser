/* globals moment*/

import Ember from 'ember';

export default Ember.Helper.helper(params => {
  const date = params[0];

  return moment(date).format('MMMM D YYYY');
});
