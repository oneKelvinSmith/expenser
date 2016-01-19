import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  actions: {
    remove: function(model) {
      model.destroyRecord();
    }
  },

  model: function() {
    return this
      .store
      .findAll('expense')
      .then(expenses => {
        return expenses.sortBy('datetime');
      });
  }
});
