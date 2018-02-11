# encoding: utf-8

# ------------------------------------------------------------------------------
# Copyright (c) 2006 Novell, Inc. All Rights Reserved.
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail, you may find
# current contact information at www.novell.com.
# ------------------------------------------------------------------------------

# File:	include/iplb/complex.ycp
# Package:	Configuration of iplb
# Summary:	Dialogs definitions
# Authors:	Cong Meng <cmeng@novell.com>
#
# $Id: complex.ycp 41350 2007-10-10 16:59:00Z dfiser $
module Yast
  module IplbComplexInclude
    def initialize_iplb_complex(include_target)
      Yast.import "UI"

      textdomain "iplb"

      Yast.import "Label"
      Yast.import "Popup"
      Yast.import "Wizard"
      #import "Wizard_hw";
      Yast.import "Confirm"
      Yast.import "Iplb"


      Yast.include include_target, "iplb/helps.rb"
    end

    # Return a modification status
    # @return true if data was modified
    def Modified
      Iplb.Modified
    end

    def ReallyAbort
      !Iplb.Modified || Popup.ReallyAbort(true)
    end

    def PollAbort
      UI.PollInput == :abort
    end

    # Read settings dialog
    # @return `abort if aborted and `next otherwise
    def ReadDialog
      Wizard.RestoreHelp(Ops.get_string(@HELPS, "read", ""))
      # Iplb::SetAbortFunction(PollAbort);
      return :abort if !Confirm.MustBeRoot
      ret = Iplb.Read
      ret ? :next : :abort
    end

    # Write settings dialog
    # @return `abort if aborted and `next otherwise
    def WriteDialog
      Wizard.RestoreHelp(Ops.get_string(@HELPS, "write", ""))
      # Iplb::SetAbortFunction(PollAbort);
      ret = Iplb.Write
      ret ? :next : :abort
    end

    # Summary dialog
    # @return dialog result
    def SummaryDialog
      # Iplb summary dialog caption
      caption = _("IPLB Configuration")

      # Frame label
      contents = nil # Wizard_hw::DetectedContent(_("IPLB to Configure"),
      #	    unconfigured, false, configured);

      Wizard.SetContentsButtons(
        caption,
        contents,
        Ops.get_string(@HELPS, "summary", ""),
        Label.BackButton,
        Label.FinishButton
      )

      ret = nil
      while true
        ret = UI.UserInput

        # abort?
        if ret == :abort || ret == :cancel || ret == :back
          if ReallyAbort()
            break
          else
            next
          end
        # overview dialog
        elsif ret == :edit_button
          ret = :overview
          break
        # configure the selected device
        elsif ret == :configure_button
          # TODO FIXME: check for change of the configuration
          selected = UI.QueryWidget(Id(:detected_selbox), :CurrentItem)
          if selected == :other
            ret = :other
          else
            ret = :configure
          end
          break
        elsif ret == :next
          break
        else
          Builtins.y2error("unexpected retcode: %1", ret)
          next
        end
      end

      deep_copy(ret)
    end

    # Overview dialog
    # @return dialog result
    def OverviewDialog
      # Iplb overview dialog caption
      caption = _("IPLB Overview")

      # FIXME table header
      contents = nil
      #Wizard_hw::ConfiguredContent(
      # Table header
      #	`header(_("Number"), _("IPLB")),
      #	overview, nil, nil, nil, nil );

      contents = nil # Wizard_hw::SpacingAround(contents, 1.5, 1.5, 1.0, 1.0);

      #	Wizard::SetContents("Cluster, contents", "help", true, true);

      Wizard.SetContentsButtons(
        caption,
        contents,
        Ops.get_string(@HELPS, "overview", ""),
        Label.BackButton,
        Label.FinishButton
      )

      Wizard.HideBackButton

      ret = nil
      while true
        ret = UI.UserInput

        # abort?
        if ret == :abort || ret == :cancel
          if ReallyAbort()
            break
          else
            next
          end
        # add
        elsif ret == :add_button
          # FIXME
          ret = :add
          break
        # edit
        elsif ret == :edit_button
          # FIXME
          ret = :edit
          break
        # delete
        elsif ret == :delete_button
          # FIXME
          next
        elsif ret == :next || ret == :back
          break
        else
          Builtins.y2error("unexpected retcode: %1", ret)
          next
        end
      end

      deep_copy(ret)
    end
  end
end
