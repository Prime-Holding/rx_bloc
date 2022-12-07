package com.primeholding.rxbloc_generator_plugin.ui;

import com.android.annotations.Nullable;
import com.intellij.openapi.ui.DialogWrapper;
import com.intellij.ui.components.JBCheckBox;
import com.intellij.ui.components.JBList;
import com.primeholding.rxbloc_generator_plugin.generator.parser.Bloc;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.List;

public class ChooseBlocsDialog extends DialogWrapper {

    private final List<Bloc> allBlocs;
    private final List<Bloc> allowedBlocs;
    private final List<Bloc> initiallySelectedBlocs;
    JBCheckBox includeBlocDi = new JBCheckBox("Generate DI/Mocks from BloC constructor", true);


    public ChooseBlocsDialog(List<Bloc> allBlocs, List<Bloc> initiallySelectedBlocs) {
        super(true);
        this.allBlocs = allBlocs;
        this.allowedBlocs = new ArrayList<>(initiallySelectedBlocs);
        this.initiallySelectedBlocs = initiallySelectedBlocs;
        initiallySelectedBlocs.clear();
        setTitle("Select BloCs");
        setOKButtonText("Create");
        setModal(true);
        init();
    }

    @Nullable
    @Override
    protected JComponent createCenterPanel() {
        JPanel dialogPanel = new JPanel(new BorderLayout(0, 5));

        JBList<Bloc> list = new JBList<>(allBlocs.toArray(new Bloc[0]));
        list.setCellRenderer(new CheckListRenderer());
        list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

        list.addMouseListener(new MouseAdapter() {
                                  @Override
                                  public void mousePressed(MouseEvent e) {
                                      int index = list.locationToIndex(e.getPoint());
                                      if (index != -1) {
                                          Bloc value = allBlocs.get(index);
                                          if (allowedBlocs.contains(value)) {
                                              boolean newValue = initiallySelectedBlocs.contains(value);
                                              if (newValue) {
                                                  // rethink this, as it uses a side effect of - pass value by reference (the
                                                  // select blocs list).
                                                  if (initiallySelectedBlocs.contains(value)) {
                                                      initiallySelectedBlocs.remove(value);
                                                  } else {
                                                      initiallySelectedBlocs.add(value);
                                                  }
                                              } else {
                                                  initiallySelectedBlocs.add(value);
                                              }

                                              repaint();
                                          }
                                      }
                                  }
                              }

        );
        dialogPanel.add(new JScrollPane(list), BorderLayout.CENTER);
        dialogPanel.add(includeBlocDi, BorderLayout.SOUTH);
        dialogPanel.add(new JLabel("Bootstrap code for Unit & Golden tests will be created under the folder(s) test/feature_{selected_feature}"), BorderLayout.NORTH);

        return dialogPanel;
    }

    public boolean includeDiMocks() {
        return includeBlocDi.isSelected();
    }

    class CheckListRenderer extends JCheckBox implements ListCellRenderer<Bloc> {
        public Component getListCellRendererComponent(JList list, Bloc value,
                                                      int index, boolean isSelected, boolean hasFocus) {
            setSelected(initiallySelectedBlocs.contains(value));
            setFont(list.getFont());
            setEnabled(allowedBlocs.contains(value));
            setBackground(list.getBackground());
            setForeground(list.getForeground());
            setText((value.isLib() ? "lib" : "feature") + "_" + value.getFile().getName().replace("_bloc.dart", ""));
            return this;
        }
    }

}
