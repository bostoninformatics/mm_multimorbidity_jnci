# Tweak multimorbidity map based on Clark's feedback.
tweak_ccw = function(ccw_tb) {
  ccw_tmp1 = ccw_tb

  ccw_tmp1 = ccw_tmp1 %>%
      mutate(alzheimersdiseaseandrelateddisordersorseniledementia =
          as.numeric(alzheimersdisease |
                     alzheimersdiseaseandrelateddisordersorseniledementia)) %>%
      select(-alzheimersdisease)

  ccw_tmp1 = ccw_tmp1 %>%
      mutate(schizophreniaandotherpsychoticdisorders =
          as.numeric(schizophrenia |
                     schizophreniaandotherpsychoticdisorders)) %>%
      select(-schizophrenia)

  ccw_tmp1 = ccw_tmp1 %>%
      mutate(intellectualdisabilitiesandrelatedconditions =
          as.numeric(learningdisabilities |
                     intellectualdisabilitiesandrelatedconditions)) %>%
      select(-learningdisabilities)

  ccw_tmp1 = ccw_tmp1 %>%
      mutate(mooddisorders = as.numeric(anxietydisorders |
                                        depression |
                                        depressivedisorders |
                                        posttraumaticstressdisorderptsd)) %>%
      select(-anxietydisorders,
             -depression,
             -depressivedisorders,
             -posttraumaticstressdisorderptsd)

  ccw_tmp1
}
