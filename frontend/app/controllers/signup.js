/* eslint camelcase:0 */

import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    register: function register() {
      const { email, password } = this.getProperties('email', 'password');

      const data = {
        email: email,
        password: password,
        password_confirmation: this.get('confirmation')
      };

      const success = () => {
        this
          .get('session')
          .authenticate('authenticator:devise', email, password);
      };

      const failure = ({ responseJSON }) => {
        this
          .set('errors', responseJSON.errors.full_messages);
      };

      Ember.$
        .post(ENV.apiURL + '/auth', data, 'json')
        .then(success, failure);
    }
  }
});
