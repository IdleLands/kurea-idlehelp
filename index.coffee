module.exports = (Module) ->
  _ = {}
  _.str = require "underscore.string"
  cheerio = require 'cheerio'
  ent = require 'ent'
  request = require 'request'

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
      
      @addRoute "status", (origin) =>
        @reply origin, "http://gunshowcomic.com/comics/20130109.png"

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

      @addRoute "doks *", (origin, route) =>
        @reply origin, "http://doks.idle.land/#!/?filter=#{encodeURIComponent route.splats[0]}"

      @on 'message', (bot, sender, channel, message) =>
        regex = /#(\d+)/g
        while issue = regex.exec message
          link = "https://github.com/IdleLands/IdleLands/issues/#{issue[1]}"

          request link, (e,r,body) =>
            return unless r
            return if r.headers['content-type']?.indexOf('text/html') is -1
            $ = cheerio.load body
            title = $('title').html()?.replace(/\r?\n|\r/g, '').trim()
            return unless title
            title = ent.decode title
            bot.say channel, title if title?

  IdleHelpModule
