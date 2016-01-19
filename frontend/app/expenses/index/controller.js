/* globals moment */

import Ember from 'ember';

const { computed, isPresent } = Ember;

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

  filtered: computed('model', 'description', function() {
    const description = this.get('description');
    const start = this.get('start');
    const end = this.get('end');

    let filtered = this.get('model');

    if (isPresent(description)) {
      filtered = this.filterByDescription(filtered, description);
    }

    if (isPresent(start) || isPresent(end)) {
      filtered = this.filterByTime(filtered, start, end);
    }

    return filtered;
  }),

  filterByDescription: function(expenses, description) {
    return expenses.filter(expense => {
      return expense
        .get('description')
        .toLowerCase()
        .indexOf(description.toLowerCase()) > -1;
    });
  },

  filterByTime: function(expenses, start, end) {
    return expenses.filter(expense => {
      return moment(expense.get('datetime')).isBetween(start, end);
    });
  }
});
