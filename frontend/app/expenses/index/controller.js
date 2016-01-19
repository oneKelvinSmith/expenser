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
    const sorted = this.get('model');
    const description = this.get('description');

    if (isPresent(description)) {
      return this.filterByDescription(sorted, description);
    }

    return sorted;
  }),

  report: computed('model.@each.datetime', function() {
    const weekStart = moment().startOf('isoWeek').startOf('day');
    const weekEnd = moment().endOf('isoWeek').endOf('day');
    const expenses = this.filterByTime(this.get('model'), weekStart, weekEnd);
    const totalAmount = this.totalAmount(expenses);
    const dailyAverage = this.dailyAverage(totalAmount);

    const report = Ember.Object.create({
      weekEnd: weekEnd,
      weekStart: weekStart,
      totalAmount: totalAmount,
      dailyAverage: dailyAverage
    });

    return report;
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
  },

  totalAmount: function(expenses) {
    return expenses.reduce((sum, expense) => sum + expense.get('amount'), 0);
  },

  dailyAverage: function(totalAmount) {
    return (totalAmount / 7).toFixed(2);
  }
});
