import Ember from 'ember';
import config from '../config/environment';

export default Ember.Service.extend({
  session: Ember.inject.service('session'),

  register: function register(credentials) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      const success = response => {
        const { email, password } = credentials;

        this
          .get('session')
          .authenticate('authenticator:oauth2', email, password);

        resolve(response);
      };

      const failure = ({ responseJSON }) => {
        reject(responseJSON.errors);
      };

      Ember.$
        .post(config.apiURL + '/signup', credentials, 'json')
        .then(success, failure);
    });
  }
});
