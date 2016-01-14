import Ember from 'ember';
import ESASession from 'ember-simple-auth/services/session';

export default ESASession.extend({
  store: Ember.inject.service(),

  setCurrentUser: function() {
    if (this.get('isAuthenticated')) {
      this.set('currentUser', this.get('session.content.authenticated.uid'));
    }
  }.observes('isAuthenticated')

});
