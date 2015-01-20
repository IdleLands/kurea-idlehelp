module.exports = (Module) ->
  _ = {}
  _.str = require "underscore.string"

  class IdleHelpModule extends Module
    shortName: "IdleHelp"
    helpText:
      default: "I can get a wiki page for IdleLands!"
      'player': 'I can get you a link to a players page!'
      'repo': 'I can get the repo link for IdleLands!'
      'global': 'I can link you to any of the global pages quickly!'
      'issue': 'Get the page for an issue!'
    usage:
      default: "wiki [page]"
      'repo': "repo"
      'player': "player [player-name]"
      'global': "global [page]"
      'issue': "issue [issue-number]"

    constructor: (moduleManager) ->
      super moduleManager

      @addRoute "repo", (origin) =>
        @reply origin, "https://github.com/IdleLands/IdleLands"

      @addRoute "player :player", (origin, route) =>
        @reply origin, "http://idle.land/s/stats/#{route.params.player}"

      @addRoute "global :page", (origin, route) =>
        @reply origin, "http://idle.land/s/#{route.params.page}"

      @addRoute "wiki :page?", (origin, route) =>
        page = route.params.page or ''
        @reply origin, "https://github.com/IdleLands/IdleLands/wiki/#{_.str.slugify page}"

      @addRoute "issue :issue", (origin, route) =>
        @reply origin, "https://github.com/IdleLands/IdleLands/issues/#{route.params.issue}"

  IdleHelpModule