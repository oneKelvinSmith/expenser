/* eslint camelcase:0 */

import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    register: function() {
      const { email, password } = this.getProperties('email', 'password');
      const data = {
        email: email,
        password: password,
        password_confirmation: this.get('confirmation')
      };

      Ember.$
        .post(ENV.apiURL + '/users', data, 'json')
        .then(() => {
          this
            .get('session')
            .authenticate('authenticator:devise', email, password);
        }, ({ responseJSON }) => {
          // console.log(responseJSON);
        });
    }
  }
});
