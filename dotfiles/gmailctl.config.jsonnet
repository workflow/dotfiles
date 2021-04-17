// Uncomment if you want to use the standard library.
// local lib = import 'gmailctl.libsonnet';
{
  version: "v1alpha3",
  author: {
    name: "Florian Peter",
    email: ""
  },
  // Note: labels management is optional. If you prefer to use the
  // GMail interface to add and remove labels, you can safely remove
  // this section of the config.
  labels: [
    {
      name: "300"
    },
    {
      name: "Bank Marketing"
    },
    {
      name: "Bank Stuff/Austrian Mastercard"
    },
    {
      name: "ZZZ_Sirenio/Applications"
    },
    {
      name: "ZZZ_Bali"
    },
    {
      name: "Company Culture"
    },
    {
      name: "Crowdfunding"
    },
    {
      name: "ZZZ_Sirenio/Customer Emails"
    },
    {
      name: "ZZZ_Danish"
    },
    {
      name: "ZZZ_Sirenio/Domain"
    },
    {
      name: "ZZZ_Bank Stuff/DKB"
    },
    {
      name: "ZZZ_Email Marketing"
    },
    {
      name: "ZZZ_Sirenio/Funding and Support"
    },
    {
      name: "ZZZ_Hosting"
    },
    {
      name: "ZZZ_Sirenio/Funding and Support/London"
    },
    {
      name: "ZZZ_Sirenio"
    },
    {
      name: "Recruiters"
    },
    {
      name: "Bank Stuff/Renault"
    },
    {
      name: "Taxes and Incorporation"
    },
    {
      name: "ZZZ_Twinbox"
    },
    {
      name: "ZZZ_Sirenio/Ropes/e-magik"
    },
    {
      name: "ZZZ_Sirenio/Ropes/Magloft"
    },
    {
      name: "ZZZ_Sirenio/Ropes/OneBit"
    },
    {
      name: "Gabi"
    },
    {
      name: "Barepack"
    },
    {
      name: "ZZZ_Sirenio/Potential Employees"
    },
    {
      name: "HD"
    },
    {
      name: "ZZZ_HN"
    },
    {
      name: "ZZZ_TenX Receipts"
    },
    {
      name: "ZZZ_Folders"
    },
    {
      name: "ZZZ_Holzweg"
    },
    {
      name: "TenX_Transactions"
    },
    {
      name: "ZZZ_BSc and CE"
    },
    {
      name: "Taxes/18"
    },
    {
      name: "Poker/Mavin"
    },
    {
      name: "Austrian Bureaucrazy"
    },
    {
      name: "ZZZ_Bildungsbaustein.at"
    },
    {
      name: "ZZZ_Hobbit Castle"
    },
    {
      name: "Bob"
    },
    {
      name: "ZZZ_Langbein und Partner/SCOPTI"
    },
    {
      name: "C.sisylanA"
    },
    {
      name: "ZZZ_Civil Service"
    },
    {
      name: "ZZZ_Coyote"
    },
    {
      name: "Taxes/19"
    },
    {
      name: "ZZZ_UBI"
    },
    {
      name: "Adventures"
    },
    {
      name: "ZZZ_Duschlauch"
    },
    {
      name: "Singapore Taxes"
    },
    {
      name: "ZZZ_Jablonsky"
    },
    {
      name: "Ebay"
    },
    {
      name: "Family"
    },
    {
      name: "Family/East"
    },
    {
      name: "Family/West"
    },
    {
      name: "Grab Txs"
    },
    {
      name: "ZZZ_GreenerDomains"
    },
    {
      name: "ZZZ_Sirenio/Dev Partnerships"
    },
    {
      name: "ZZZ_Hobbit Hole I"
    },
    {
      name: "Right Knee ACL Tear"
    },
    {
      name: "ZZZ_Recipes"
    },
    {
      name: "Poker/Crypto"
    },
    {
      name: "ZZZ_HostICan"
    },
    {
      name: "ZZZ_I-kiu"
    },
    {
      name: "Airlines"
    },
    {
      name: "ZZZ_I-kiu/213"
    },
    {
      name: "ZZZ_Sirenio/Petty Cash"
    },
    {
      name: "ZZZ_Nalinsart"
    },
    {
      name: "ZZZ_I-kiu/Akkadia"
    },
    {
      name: "ZZZ_Sirenio/partnerships"
    },
    {
      name: "Edupine"
    },
    {
      name: "ZZZ_I-kiu/Ama"
    },
    {
      name: "ZZZ_Wild Family Finance"
    },
    {
      name: "ZZZ_I-kiu/Amalthea"
    },
    {
      name: "ZZZ_I-kiu/Biodiesel"
    },
    {
      name: "ZZZ_I-kiu/Div"
    },
    {
      name: "ZZZ_I-kiu/HH"
    },
    {
      name: "ZZZ_I-kiu/I-fun"
    },
    {
      name: "ZZZ_Vera"
    },
    {
      name: "ZZZ_I-kiu/I-kiu SRV"
    },
    {
      name: "ZZZ_I-kiu/Ki"
    },
    {
      name: "TenX"
    },
    {
      name: "Wedding"
    },
    {
      name: "ZZZ_Archives/2011"
    },
    {
      name: "ZZZ_I-kiu/Lagerbox"
    },
    {
      name: "ZZZ_I-kiu/Project Green Ethanol"
    },
    {
      name: "ZZZ_I-kiu/Toppits"
    },
    {
      name: "California"
    },
    {
      name: "ZZZ_Sirenio/CSVs"
    },
    {
      name: "ZZZ_I-kiu/Vector"
    },
    {
      name: "ZZZ_Taxes/17"
    },
    {
      name: "ZZZ_I-kiu/Ventura"
    },
    {
      name: "Tirol"
    },
    {
      name: "ZZZ_Lil Projects"
    },
    {
      name: "ZZZ_Maori"
    },
    {
      name: "WG Hunoldstrasse"
    },
    {
      name: "ZZZ_Unbilled Sirenio Expenses"
    },
    {
      name: "Plant World"
    },
    {
      name: "Poker"
    },
    {
      name: "ZZZ_Archives/2012"
    },
    {
      name: "Poker/Angel Investing"
    },
    {
      name: "Poker/Renault Bank"
    },
    {
      name: "ZZZ_Sirenio/Test Reports"
    },
    {
      name: "ZZZ_SV"
    },
    {
      name: "Sailin"
    },
    {
      name: "ZZZ_Sev"
    },
    {
      name: "ZZZ_Roshan"
    },
    {
      name: "ZZZ_Shorthand"
    },
    {
      name: "ZZZ_Sirenio/Seed Round"
    },
    {
      name: "ZZZ_Speck"
    },
    {
      name: "ZZZ_Surfmed"
    },
    {
      name: "ZZZ_Surfmed/Groupware 2015"
    },
    {
      name: "ZZZ_Surfmed/eGroupWare"
    },
    {
      name: "ZZZ_Taxes (ARCHIVE)"
    },
    {
      name: "Secret"
    },
    {
      name: "ZZZ_Taxes/12"
    },
    {
      name: "Odesa"
    },
    {
      name: "Deep Learning"
    },
    {
      name: "ZZZ_Taxes/13"
    },
    {
      name: "OSS"
    },
    {
      name: "ZZZ_Sirenio/Ideas"
    },
    {
      name: "ZZZ_Taxes/14"
    },
    {
      name: "Accounting"
    },
    {
      name: "ZZZ_Taxes/15"
    },
    {
      name: "Kematen"
    },
    {
      name: "ZZZ_Taxes/16"
    },
    {
      name: "Gaia"
    },
    {
      name: "ZZZ_Time of the Vulture"
    },
    {
      name: "ZZZ_Snabel Research"
    },
    {
      name: "Singapore"
    },
    {
      name: "Singapore/Proof of Address"
    },
    {
      name: "Tom"
    },
    {
      name: "Geli April 2019 Trip"
    },
    {
      name: "ZZZ_Sirenio/Investor Lists"
    },
    {
      name: "ZZZ_Tyrol"
    },
    {
      name: "Ale Flyouts"
    },
    {
      name: "EF"
    },
    {
      name: "Bagpipes"
    },
    {
      name: "ZZZ_UBRM"
    },
    {
      name: "Singapore/UOB"
    },
    {
      name: "ZZZ_UseneXt"
    },
    {
      name: "Singapore/Ferraria Park"
    },
    {
      name: "ZZZ_Verbal"
    },
    {
      name: "ZZZ_WaV"
    },
    {
      name: "ZZZ_Wild Plains"
    },
    {
      name: "ZZZ_Deep Betting"
    },
    {
      name: "ZZZ_ÖI"
    },
    {
      name: "ZZZ_Lein2012"
    },
    {
      name: "Crypto"
    },
    {
      name: "Ma"
    },
    {
      name: "Crypto TXs"
    },
    {
      name: "Kat's Parents Phuket Trip"
    },
    {
      name: "Bank Stuff"
    },
    {
      name: "ZZZ_Outdoor"
    },
    {
      name: "ZZZ_Sirenio/Reflections"
    },
    {
      name: "ZZZ_Personal Development"
    },
    {
      name: "Cortina"
    },
    {
      name: "ZZZ_SMA"
    },
    {
      name: "ZZZ_Sirenio/Sales"
    },
    {
      name: "ZZZ_Sem to the Ring"
    },
    {
      name: "ZZZ_Folders/Sent"
    },
    {
      name: "Ropes"
    },
    {
      name: "ZZZ_Cali"
    },
    {
      name: "Advisors"
    },
    {
      name: "AI"
    }
  ],
  rules: [
    # Delete Boiteajeux turn notifications
    {
      filter: {
      	and: [
	  { from: "robot@boiteajeux" },
	  { subject: "Your turn" },
      	],
      },
      actions: {
        markRead: true,
	delete: true,
      }
    },

    # Ignore AmazonFresh Delivery Mails
    {
      filter: {
      	and: [
	  { from: "auto-confirm@amazon.sg" },
	  { subject: "Your Amazon Fresh order has been received" },
      	],
      },
      actions: {
        markRead: true,
        archive: true
      }
    },


    {
      filter: {
        from: "umsatznachricht@cardcomplete.com"
      },
      actions: {
        markRead: true,
        labels: [
          "Bank Stuff/Austrian Mastercard"
        ]
      }
    },
    {
      filter: {
        from: "rechnung@drei.at"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "rechnung@drei.at"
          },
          {
            subject: "Ihre 3Rechnung",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "sales.de@jetbrains.com"
          },
          {
            subject: "License Certificate for JetBrains WebStorm",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "info@shifuyanlei.co.uk"
          },
          {
            subject: "Fighting  Meditation",
            isEscaped: true
          }
        ]
      },
      actions: {
        labels: [
          "300"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "service@paypal.at"
          },
          {
            subject: "Bestätigung Ihrer Zahlung an GitHub, Inc.",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "support@torguard.net"
          },
          {
            subject: "Invoice Payment Confirmation",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "help@expensify.com"
          },
          {
            subject: "[Expensify] Billing Receipt",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "noreply@renault-bank-direkt.at"
          },
          {
            subject: "Ihr aktueller Kontoauszug befindet sich in Ihrem e-Postfach",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Poker"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "support@github.com"
          },
          {
            subject: "[GitHub] Payment Receipt for workflow",
            isEscaped: true
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "billing@hetzner.com"
          },
          {
            query: "Invoice has:attachment"
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Taxes/18"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "umsatznachricht@cardcomplete.com"
          },
          {
            query: "has:attachment"
          }
        ]
      },
      actions: {
        labels: [
          "Bank Stuff/Austrian Mastercard"
        ]
      }
    },
    {
      filter: {
        from: "more@mastercardmonatsrechnung.at"
      },
      actions: {
        labels: [
          "Bank Stuff/Austrian Mastercard"
        ]
      }
    },
    {
      filter: {
        query: "list:crypto-gram.lists.schneier.com"
      },
      actions: {
        archive: true,
        labels: [
          "C.sisylanA"
        ]
      }
    },
    {
      filter: {
        from: "team@tenx.tech"
      },
      actions: {
        labels: [
          "TenX"
        ]
      }
    },
    {
      filter: {
        from: "noreply@renault-bank-direkt.at"
      },
      actions: {
        labels: [
          "Poker/Renault Bank"
        ]
      }
    },
    {
      filter: {
        query: "contact@helpling.sg"
      },
      actions: {
        markRead: true,
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        from: "service@extrasauber.at"
      },
      actions: {
        markRead: true,
        labels: [
          "Ma"
        ],
        forward: "alessandra.peter@gmail.com"
      }
    },
    {
      filter: {
        query: "messages@bullionvault.com"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Poker"
        ],
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        from: "hello@splitwise.com"
      },
      actions: {
        markRead: true,
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        and: [
          {
            from: "cdponline@alerts.sgx.com"
          },
          {
            subject: "Your SGX CDP Account Statement is ready",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Poker"
        ],
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        and: [
          {
            from: "no-reply@grab.com"
          },
          {
            subject: "Your Grab E-Receipt",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        and: [
          {
            from: "cdponline@alerts.sgx.com"
          },
          {
            subject: "Your SGX CDP Notification is ready",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Poker"
        ],
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        and: [
          {
            from: "info@mail.foodpanda.sg"
          },
          {
            subject: "Your foodpanda order",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        and: [
          {
            from: "info@mail.foodpanda.sg"
          },
          {
            subject: "Your order has been placed",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        query: "Your Citibank Credit Card statement is ready for viewing"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            subject: "Your Credit Card Combined e-Statement",
            isEscaped: true
          },
          {
            query: "from:(estatement@ocbc.com) ((has:attachment OR has:drive) estatement@ocbc.com)"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ],
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        and: [
          {
            from: "App Center Team",
            isEscaped: true
          },
          {
            query: "subject:Version"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        and: [
          {
            from: "alerts@citibank.com.sg"
          },
          {
            query: "\"Ready Credit Payment Due\""
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "noreply@t.deliveroo.com"
          },
          {
            subject: "Your order's in the kitchen",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        from: "AsiaPendedClaims@cigna.com"
      },
      actions: {
        forward: "veronika.ukrainets@gmail.com"
      }
    },
    {
      filter: {
        query: "eStatement.SG@sc.com"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        from: "onlinestatements@welcome.aexp.com"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "alerts.sg@sc.com"
          },
          {
            query: "\"Payment Due\" \"Statement balance\""
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "estatement@ocbc.com"
          },
          {
            query: "\"monthly e-Statement\""
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "noreply@t.deliveroo.com"
          },
          {
            subject: "has accepted your order",
            isEscaped: true
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        query: "Your HSBC VISA REVOLUTION eStatement"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "support@rebatemango.com"
          },
          {
            query: "\"You have new cashback/rewards added. View here.\""
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        and: [
          {
            from: "ibanking.alert@dbs.com"
          },
          {
            query: "\"your credit card estatement is ready\""
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "@mail.hsbc.com.sg"
          },
          {
            query: "Your HSBC credit card eStatement is ready"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },

    # Ignore OCBC Marketing Emails
    {
      filter: {
        and: [
          {
            from: "cards_m@ocbc.com"
          },
          {
            subject: "<ADV>"
          },
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Marketing"
        ]
      }
    },

    # Ignore DBS Marketing Emails
    {
      filter: {
        and: [
          {
            from: "emktg@dbs.com"
          },
          {
            subject: "<ADV>"
          },
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Marketing"
        ]
      }
    },

    # Archive and Keep DBS Statments
    {
      filter: {
        and: [
          {
            from: "ibanking.alert@dbs.com"
          },
	  {
	    or: [
              { subject: "Your DBS/POSB Consolidated Statement is ready for viewing" },
	      { subject: "View your DBS/POSB Consolidated Statement" },
	    ],
	  },
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Bank Stuff"
        ]
      }
    },

    {
      filter: {
        query: "DBS Vickers Online Statement Notification"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "Poker"
        ]
      }
    },
    {
      filter: {
        query: "Schmiderer.Christian@gmx.at"
      },
      actions: {
        archive: true,
        labels: [
          "Tirol"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "hello@email.shopback.sg"
          },
          {
            query: "Your Cashback is now Confirmed!"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        and: [
          {
            from: "hello@email.shopback.sg"
          },
          {
            query: "Your latest transaction from ShopBack Voucher"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        from: "riparbella@riparbella.com"
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        and: [
          {
            from: "hello@email.shopback.sg"
          },
          {
            query: "\"Your latest transactions\""
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true
      }
    },

    # ViewQwest Invoices that serve as Proof of Address
    {
      filter: {
        and: [
          {
            from: "billing@viewqwest.com"
          },
          {
            query: "Invoice is attached"
          }
        ]
      },
      actions: {
        markRead: true,
        labels: [
          "Singapore",
	  "Singapore/Proof of Address",
        ]
      }
    }
  ]
}
