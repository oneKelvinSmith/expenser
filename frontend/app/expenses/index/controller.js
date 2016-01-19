import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    remove: function(model) {
      model
        .destroyRecord()
        .then(() => {
          this
            .get('model')
            .removeObject(model);
        });
    }
  },

  filtered: Ember.computed('model', 'description', function() {
    const sorted = this.get('model');
    const description = this.get('description');

    if (description) {
      return sorted.filter(expense => {
        return expense
          .get('description')
          .toLowerCase()
          .indexOf(description.toLowerCase()) > -1;
      });
    }

    return sorted;
  })
});
