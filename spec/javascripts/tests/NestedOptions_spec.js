describe('show hidden options on checkbox change', function () {
  'use strict';

  var $html, $nestedOptionsComponent, $nestedOptionsTrigger, $nestedOptions;

  beforeEach(function(done){
    var self = this;

    requirejs(['NestedOptions'], function (NestedOptions) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/NestedOptions.html']).appendTo('body');
      self.$nestedOptionsComponent = $('[data-nested-options-component]');
      self.$nestedOptionsTrigger = $('[data-nested-options-trigger]');
      self.$nestedOptions = $('[data-nested-options]');
      new NestedOptions();
      done();
    });
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('NestedOptions is loaded', function() {
    it('page elements exist', function() {
      expect(this.$nestedOptionsComponent).to.exist;
      expect(this.$nestedOptions).to.exist;
      expect(this.$nestedOptionsTrigger).to.exist;
    });

    it('is hidden on default', function() {
      expect(this.$nestedOptions).to.have.class('is-hidden');
    });

    it('hidden options are shown on checkbox change', function() {
      this.$nestedOptionsTrigger.trigger('click');
      expect(this.$nestedOptionsTrigger).to.be.checked;
      expect(this.$nestedOptions).to.not.have.class('is-hidden');
    });
  });
});
