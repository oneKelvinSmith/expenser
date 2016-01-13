import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    authenticate: function authenticate() {
      const { email, password } = this.getProperties('email', 'password');

      this
        .get('session')
        .authenticate('authenticator:devise', email, password)
        .catch(({ errors }) => this.set('errors', errors));
    }
  }
});
