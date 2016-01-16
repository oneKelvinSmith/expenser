import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    login: function authenticate() {
      const { email, password } = this.getProperties('email', 'password');

      const failure = ({ error_description }) => {
        this.set('errors', [error_description]);
      };

      this
        .get('session')
        .authenticate('authenticator:oauth2', email, password)
        .catch(failure);
    }
  }
});
