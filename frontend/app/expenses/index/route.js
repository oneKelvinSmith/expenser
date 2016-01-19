import Ember from 'ember';

export default Ember.Route.extend({
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
