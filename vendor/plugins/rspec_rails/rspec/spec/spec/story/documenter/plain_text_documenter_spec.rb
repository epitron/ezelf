require File.dirname(__FILE__) + '/../story_helper'

module Spec
  module Story
    module Documenter
      describe PlainTextDocumenter do
        before :each do
          # given
          @out = String.new
          @documenter = PlainTextDocumenter.new(@out)
        end
        
        it 'should document a story title and narrative' do
          # when
          @documenter.story_started 'story', 'narrative'
          
          # then
          @out.should contain("Story: story\nnarrative\n")
        end
        
        it 'should document a scenario name' do
          # when
          @documenter.scenario_started 'story', 'scenario'
          
          # then
          @out.should contain("\nScenario: scenario\n")
        end
        
        it 'should document a step by sentence-casing its name' do
          # when
          @documenter.found_step :given, 'a context'
          @documenter.found_step :when, 'an event'
          @documenter.found_step :then, 'an outcome'
          
          # then
          @out.should contain("  Given a context\n  When an event\n  Then an outcome\n")
        end
        
        it 'should print some white space after each story' do
          # when
          @documenter.story_ended 'title', 'narrative'
          
          # then
          @out.should contain("\n\n")
        end
        
        it 'should ignore uninteresting calls' do
          # when
          @documenter.run_started(42)
          @documenter.run_ended
          @documenter.scenario_succeeded('story', 'scenario')
          @documenter.scenario_failed('story', 'scenario', RuntimeError.new)
          @documenter.scenario_pending('story', 'scenario', 'todo')
          
          # then
          @out.should be_empty
        end
      end
    end
  end
end
