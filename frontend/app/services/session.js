import Ember from 'ember';
import ESASession from 'ember-simple-auth/services/session';

export default ESASession.extend({
  store: Ember.inject.service(),

  setCurrentUser: function() {
    if (this.get('isAuthenticated')) {
      console.log(this.get('session.content'));
      this.set('currentUser', this.get('NOT IMPLEMENTED'));
    }
  }.observes('isAuthenticated')
});
