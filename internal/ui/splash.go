// SPDX-License-Identifier: Apache-2.0
// Copyright Authors of K9s

package ui

import (
	"fmt"
	"strings"

	"github.com/derailed/k9s/internal/config"
	"github.com/derailed/tview"
)

// LogoSmall K9s small log.
var LogoSmall = []string{
	`_______________`,
	`\__   __/  __  \  __________________`,
	`  |   |\    ___/ /  ___/  ___/  ___/`,
	`  |   | \   \   /  __/   __/   __ \ `,
	`  |___|  \___\ /_____/_____/\_____/`,
}

// LogoBig K9s big logo for splash page.
var LogoBig = []string{
	`_______________`,
	`\__   __/  __  \  __________________`,
	`  |   |\    ___/ /  ___/  ___/  ___/`,
	`  |   | \   \   /  __/   __/   __ \ `,
	`  |___|  \___\ /_____/_____/\_____/`,
}

// Splash represents a splash screen.
type Splash struct {
	*tview.Flex
}

// NewSplash instantiates a new splash screen with product and company info.
func NewSplash(styles *config.Styles, version string) *Splash {
	s := Splash{Flex: tview.NewFlex()}
	s.SetBackgroundColor(styles.BgColor())

	logo := tview.NewTextView()
	logo.SetDynamicColors(true)
	logo.SetWordWrap(false)
	logo.SetWrap(false)
	logo.SetTextAlign(tview.AlignCenter)
	s.layoutLogo(logo, styles)

	vers := tview.NewTextView()
	vers.SetDynamicColors(true)
	vers.SetWordWrap(false)
	vers.SetWrap(false)
	vers.SetTextAlign(tview.AlignCenter)
	s.layoutRev(vers, version, styles)

	s.SetDirection(tview.FlexRow)
	s.AddItem(logo, len(LogoBig)+2, 1, false)
	s.AddItem(vers, 1, 1, false)

	return &s
}

func (*Splash) layoutLogo(t *tview.TextView, styles *config.Styles) {
	logo := strings.Join(LogoBig, fmt.Sprintf("\n[%s::b]", styles.Body().LogoColor))
	_, _ = fmt.Fprintf(t, "\n[%s::b]%s\n", styles.Body().LogoColor, logo)
}

func (*Splash) layoutRev(t *tview.TextView, rev string, styles *config.Styles) {
	_, _ = fmt.Fprintf(t, "[%s::b]Revision [red::b]%s", styles.Body().FgColor, rev)
}
