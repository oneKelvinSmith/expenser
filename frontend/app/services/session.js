import Ember from 'ember';
import ESASession from 'ember-simple-auth/services/session';

export default ESASession.extend({
  setCurrentUser: function() {
    if (this.get('isAuthenticated')) {
      this.authorize('authorizer:oauth2', (headerName, headerValue) => {
        const headers = {};

        headers[headerName] = headerValue;

        Ember.$
          .ajax({
            headers: headers,
            url: '/api/current_user',
            contentType: 'json'
          })
          .done(({ user }) => {
            this.set('currentUser', user);
          });

      });
    }
  }.observes('isAuthenticated')

});
