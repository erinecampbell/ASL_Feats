library(tidyverse)
library(png)
library(grid)

load("data/ASLLexFeats.Rdata")

CDI_features_N <- concs %>%
  select(Concept, Num_Func:Num_Tax, -Num_Percep, -Num_Tax, -Num_Ency, -Num_Func) %>%
  pivot_longer(cols = Num_Vis_Mot:Num_Tact, 
               names_to = "FeatureType", 
               names_prefix = "Num_", 
               values_to = "NumberFeatures") %>%
  mutate(
    FeatureType = case_when(  # Rename the FeatureType categories
      FeatureType == "Sound" ~ "Sound (So)",
      FeatureType == "Tact" ~ "Tactile (Tc)",
      FeatureType == "Vis_Mot" ~ "Visual Motion (VM)",
      FeatureType == "Vis_Col" ~ "Visual Color (VC)",
      FeatureType == "VisFandS" ~ "Visual (VFS)\nForm and Surface",
      FeatureType == "Smell" ~ "Smell (Sm)",
      FeatureType == "Taste" ~ "Taste (Ts)",
      TRUE ~ FeatureType  # Keep any unmatched categories as-is
    ),
    FeatureType = factor(FeatureType, levels = c(  # Reorder the FeatureType categories
      "Taxonomic", "Function", "Encyclopedic", "Sound (So)", 
      "Smell (Sm)", "Taste (Ts)",
      "Tactile (Tc)", 
      "Visual Motion (VM)", "Visual Color (VC)",  "Visual (VFS)\nForm and Surface"
    ))
  ) %>%
  mutate(
    PlotFeatureType = case_when(
      FeatureType == "Visual Motion (VM)" ~ "Motion",
      FeatureType == "Visual Color (VC)" ~ "Color",
      FeatureType == "Visual (VFS)\nForm and Surface" ~ "Form &\nSurface",
      FeatureType == "Smell (Sm)" ~ "Smell",
      FeatureType == "Taste (Ts)" ~ "Taste",
      FeatureType == "Tactile (Tc)" ~ "Tactile",
      FeatureType == "Sound (So)" ~ "Sound",
      TRUE ~ FeatureType
    )
  ) %>%
  mutate(
    PlotFeatureType = factor(PlotFeatureType, levels = c(  # Reorder the FeatureType categories
      "Taxonomic", "Function", "Encyclopedic", "Sound", 
      "Smell", "Taste",
      "Tactile", 
      "Motion", "Color",  "Form &\nSurface"
    ))
  )
  

# Define custom colors for the updated FeatureTypes
feature_colors <- c(
  "Taxonomic" = "grey",
  "Function" = "grey",
  "Encyclopedic" = "grey",
  "Visual Motion (VM)" = "#70A7FF",
  "Visual Color (VC)" = "#005EF5",  
  "Visual (VFS)\nForm and Surface" = "#002766", 
  "Smell (Sm)" = "#8338EC",
  "Sound (So)" = "#FFDD00",
  "Tactile (Tc)" = "#5FAD56",
  "Taste (Ts)" = "#FF006E"
)


# Create the polar chart
polar_plot <- ggplot((CDI_features_N %>% filter(Concept %in% c("frog","lollipop","balloon","friend"))), 
       aes(x = PlotFeatureType, y = NumberFeatures, fill = FeatureType)) +  # Use PlotFeatureType for labels
  geom_col(width = 1, alpha = .7) +
  coord_polar(theta = "x", clip = "off") +
  theme_minimal() + 
  scale_fill_manual(values = feature_colors) + 
  labs(x = NULL,
       y = NULL) +
  facet_wrap(.~Concept) +
  theme(
    axis.text.y = element_blank(),  # Remove y-axis text
    axis.ticks.y = element_blank(),
    strip.background = element_rect(fill = "lightgrey", color = "white"),
    strip.text = element_text(size = 10, face = "bold"),  # Bold facet label text
  legend.position = "none"
    ) +
  theme(
    plot.margin = margin(r = 20, l = 20)  # Adjust top, right, bottom, and left margins
  )
polar_plot

# Exclude words with punctuation and randomly sample 60 Concepts
# Ensure balloon, friend, frog, and lollipop are always included
sampled_data <- CDI_features_N %>%
  filter(!str_detect(Concept, "[[:punct:]]"),
         Concept != "penis") %>%  # Exclude words with punctuation
  group_by(Concept) %>%
  mutate(TotalFeatures = sum(NumberFeatures)) %>%  # Calculate total features per Concept
  ungroup() %>%
  distinct(Concept, TotalFeatures) %>%  # Retain unique Concepts with TotalFeatures
  # Always include balloon, friend, frog, lollipop
  mutate(Included = ifelse(Concept %in% c("balloon", "friend", "frog", "lollipop"), TRUE, FALSE)) %>%
  # Randomly sample from concepts not already included
  filter(!Included) %>%
  sample_n(26) %>%  # Sample remaining concepts to reach 30 total
  bind_rows(filter(CDI_features_N, Concept %in% c("balloon", "friend", "frog", "lollipop"))) %>%
  distinct()  # Combine with always-included concepts

# Filter the original data to include only the sampled Concepts
filtered_data <- CDI_features_N %>%
  filter(Concept %in% sampled_data$Concept) %>%
  group_by(Concept) %>%
  mutate(TotalFeatures = sum(NumberFeatures)) %>%  # Calculate total features per Concept
  ungroup() %>%
  mutate(Concept = fct_reorder(Concept, TotalFeatures), # Reorder by TotalFeatures
         Abbrev = case_when(FeatureType == "Sound (So)" ~ "So",
                            FeatureType == "Smell (Sm)" ~ "Sm",
                            FeatureType == "Taste (Ts)" ~ "Ts",
                            FeatureType == "Tactile (Tc)" ~ "Tc",
                            FeatureType == "Visual Color (VC)" ~ "VC",
                            FeatureType == "Visual Motion (VM)" ~ "VM",
                            FeatureType == "Visual (VFS)\nForm and Surface" ~ "VFS"),
        Visual = case_when(FeatureType == "Sound" ~ F,
                            FeatureType == "Smell" ~ F,
                            FeatureType == "Taste" ~ F,
                            FeatureType == "Tactile" ~ F,
                            FeatureType == "Visual Color" ~ T,
                            FeatureType == "Visual Motion" ~ T,
                            FeatureType == "Visual\nForm and Surface" ~ T),
        NumberFeatures = case_when(NumberFeatures == 0 ~ "NA",
                                   TRUE ~ NumberFeatures)) 
# Create the stacked bar chart
bars_plot <- ggplot((filtered_data %>% filter(NumberFeatures > 0 | NumberFeatures == "NA") %>% distinct()), aes(x = Concept, y = NumberFeatures, fill = FeatureType, label = Abbrev)) +
  geom_col(width = 1, alpha = .7, position = "stack") +
  theme_minimal() + 
  scale_fill_manual(values = feature_colors) + 
  scale_color_manual(values = feature_colors) + 
  labs(x = NULL,
       y = "Number of Features",
       fill = "Feature Type") +  # Add legend title
  coord_flip() +  # Flip the bars horizontally
  geom_label(aes(color=FeatureType), fill = "white", position = position_stack(vjust = 0.5), size=3) +
  theme(axis.text.y = element_text(face = ifelse(levels(filtered_data$Concept) 
                                                 %in% c("balloon", "friend", "frog", "lollipop"), "bold", "plain"))) +
  guides(
    color = "none",       # remove color legend
    fill = guide_legend() # keep fill legend
  )
bars_plot

bars_plot_all <- ggplot((CDI_features_N %>% filter(!str_detect(Concept, "[[:punct:]]")) %>%
                           group_by(Concept) %>%
                           mutate(TotalFeatures = sum(NumberFeatures)) %>%  # Calculate total features per Concept
                           ungroup() %>%
                           mutate(Concept = fct_reorder(Concept, TotalFeatures))), aes(x = Concept, y = NumberFeatures, fill = FeatureType)) +
  geom_col(width = 1, alpha = .7, position = "stack") +
  theme_minimal() + 
  scale_fill_manual(values = feature_colors) + 
  labs(x = NULL,
       y = "Number of Features",
       fill = "Feature Type") +  # Add legend title
  coord_flip() 
bars_plot_all

feature_list_png <- readPNG("Figures/ASLFeats_Frog.png")

# Convert the image to a raster object for ggplot
feature_list_grob <- rasterGrob(feature_list_png, interpolate = TRUE)

# Create the ggplot
feature_list <- ggplot() +
  annotation_custom(feature_list_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  theme_void()  # Remove all axes and backgrounds
cowplot::plot_grid(feature_list, polar_plot, bars_plot, nrow=1, labels="AUTO", rel_widths = c(3,3,4))
ggsave(filename = "Figures/feature_plot.png", device="png", height = 6, width = 15)

# # Create radar chart
# radarchart(radar_data, 
#            axistype = 0,  # Show raw numbers (not percentages)
#            pcol = c("#FF006E", "#3A86FF", "#8338EC", "#FFDD00", "#5FAD56", "#FF9F1C"),  # Line colors
#            pfcol = alpha(c("#FF006E", "#3A86FF", "#8338EC", "#FFDD00", "#5FAD56", "#FF9F1C"), 0.2),  # Fill colors
#            plwd = 2,  # Line width
#            plty = 1,  # Line type
#            cglcol = "black",  # Gridline color
#            cglty = 1,  # Gridline type
#            cglwd = 0.8,  # Gridline width
#            vlcex = 1,  # Axis label size
#            caxislabels = seq(0, max(radar_data), length.out = 5))  # Custom axis labels
# 
# # Add legend
# legend(x = "topright", legend = rownames(radar_data)[-c(1,2)], bty = "n", pch = 20, 
#        col = c("#FF006E", "#3A86FF", "#8338EC", "#FFDD00", "#5FAD56", "#FF9F1C"),
#        text.col = "black", cex = 0.8, pt.cex = 1.5)
# 
