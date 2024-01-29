## NavigationSplitView for iOS / iPad 16.4+

A example implementation of Apple's NavigationSplitView for iPhone / iPad.

Implements a Library in the sidebar, with a detail view showing the selection.

Supports searching, editMode, swipeToDelete.

Takes some oddities and bugs into account / works around those, like 
  - missing toolbar icons after coming back from background,
  - selection bugs / crashes.

NOTE: onAppear / onDisappear in DetailView get's triggered in the wrong order when the selection in LibraryView changes (for .regular horizontal size classes): first onAppear of the new incoming view is called, only then onDissappear of the outgoing view is called. Different from what one would expect, when coming from a NavigationStack implementation.
