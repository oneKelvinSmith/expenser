/* eslint camelcase:0 */

import Ember from 'ember';

export default Ember.Controller.extend({
  registration: Ember.inject.service('registration'),

  actions: {
    signup: function signup() {
      const credentials = {
        email: this.get('email'),
        password: this.get('password'),
        password_confirmation: this.get('confirmation')
      };

      this
        .get('registration')
        .register(credentials)
        .catch(errors => this.set('errors', errors));
    }
  }
});
