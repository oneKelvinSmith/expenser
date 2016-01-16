/* eslint camelcase:0 */

import Ember from 'ember';
import config from '../config/environment';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    register: function register() {
      const {
        email, password, confirmation
      } = this.getProperties('email', 'password', 'confirmation');

      const credentials = {
        email: email,
        password: password,
        password_confirmation: confirmation
      };

      const success = () => {
        this
          .get('session')
          .authenticate('authenticator:oauth2', email, password);
      };

      const failure = ({ responseJSON }) => {
        this
          .set('errors', responseJSON.errors);
      };

      Ember.$
        .post(config.apiURL + '/signup', credentials, 'json')
        .then(success, failure);
    }
  }
});
